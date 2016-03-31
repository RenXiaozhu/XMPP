//
// Created by fengshuai on 14-8-7.
// Copyright (c) 2014 fengshuai. All rights reserved.


#import "SerializationHelper.h"
#import "JsonSerializableObject.h"
#import "PropertyDescriptor.h"
#import <objc/runtime.h>

//系统类型
static NSArray *systemCopyableTypes= nil;

//系统基本类型
static NSDictionary *systemPrimitiveTypes= nil;

@interface SerializationHelper ()
@property(nonatomic, strong) NSCache *classPropertyMappingCache;//记录已缓存的类型描述
@end

@implementation SerializationHelper

+ (void)load
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        @autoreleasepool {
            systemCopyableTypes = @[
                    [NSString class], [NSNumber class], [NSDecimalNumber class],
                    [NSArray class], [NSDictionary class], [NSNull class], //immutable
                    [NSMutableString class], [NSMutableArray class], [NSMutableDictionary class] //mutable
            ];

            systemPrimitiveTypes = @{
                    @"f":@"float",
                    @"i":@"int",
                    @"d":@"double",
                    @"l":@"long",
                    @"c":@"BOOL",
                    @"s":@"short",
                    @"q":@"long",
                    @"I":@"NSInteger",
                    @"Q":@"NSUInteger",
                    @"B":@"BOOL",   // BOOL is now "B" on iOS __LP64 builds
                    @"@?":@"Block"};
        }
    });
}


+ (SerializationHelper *)sharedInstance
{
    static SerializationHelper *_instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.classPropertyMappingCache = [[NSCache alloc] init];
        [self.classPropertyMappingCache setName:@"aerospace.serialization.mapping.cache"];
    }

    return self;
}


- (NSDictionary *)serializeFromObject:(id)object
{
    //获取属性列表
    //逐个属性序列化

    NSDictionary *classProperties = [self inspectPropertiesForObject:object];

    if ([classProperties count])
    {
        NSMutableDictionary *dictionary= [NSMutableDictionary dictionaryWithCapacity:classProperties.count];
        for (PropertyDescriptor *descriptor in classProperties.allValues)
        {
            id value= [object valueForKey:descriptor.propertyName];
            if (value!=nil&& ![value isKindOfClass:[NSNull class]])
            {
                if (descriptor.isPrimitive)//基本类型,直接赋值
                {
                    [dictionary setValue:value forKey:descriptor.propertyMappingKey];
                }
                else if (![value isKindOfClass:descriptor.type]) //判断类型是否兼容
                {
                    @throw [NSException exceptionWithName:@"Serialization type not matched"
                                                   reason:[NSString stringWithFormat:@"Property type of %@.%@ is not matched for value %@.", NSStringFromClass([object class]), descriptor.propertyName,value]
                                                 userInfo:nil];
                }
                else if (descriptor.isSystemCopyableType)//Array,Dictionry,String,Number,Null
                {
                    if ([descriptor.type isSubclassOfClass:[NSArray class]])
                    {
                        NSArray *array=[value copy];
                        if (descriptor.protocol.length)//泛型处理
                        {
                            Class aClass= NSClassFromString(descriptor.protocol);
                            if ([aClass isSubclassOfClass:[JsonSerializableObject class]])
                            {
                                NSMutableArray *objArray= [NSMutableArray arrayWithCapacity:array.count];
                                for (id item in array)
                                {
                                    NSDictionary *subDict= [self serializeFromObject:item];
                                    if (subDict)
                                        [objArray addObject:subDict];
                                }
                                [dictionary setValue:objArray forKey:descriptor.propertyMappingKey];
                            }
                            else
                                [dictionary setValue:value forKey:descriptor.propertyMappingKey];
                        }
                        else
                            [dictionary setValue:value forKey:descriptor.propertyMappingKey];
                    }
                    else
                    {
                        [dictionary setValue:value forKey:descriptor.propertyMappingKey];
                    }
                }
                else if ([descriptor.type isSubclassOfClass:[JsonSerializableObject class]])
                {
                    NSDictionary *subDict= [self serializeFromObject:value];
                    if (subDict)
                        [dictionary setValue:subDict forKey:descriptor.propertyMappingKey];
                }
            }
        }

        return dictionary;
    }

    return nil;
}

- (void)importDictionary:(NSDictionary *)dictionary toObject:(id)object
{
    //根据类型结构赋值
    if (dictionary== nil||![object isKindOfClass:[JsonSerializableObject class]])
        return;

    NSDictionary *classProperties = [self inspectPropertiesForObject:object];

    if ([classProperties count]==0)
        return;

    for (PropertyDescriptor *descriptor in classProperties.allValues)
    {
        id value= [dictionary valueForKey:descriptor.propertyMappingKey];
        if (value!=nil&& ![value isKindOfClass:[NSNull class]])
        {
            if (descriptor.isPrimitive)
                [object performSelector:@selector(setValue:forKey:) withObject:value withObject:descriptor.propertyName];
            else if (descriptor.isSystemCopyableType)
            {
                if ([descriptor.type isSubclassOfClass:[NSArray class]])
                {
                    NSMutableArray *mutableArray= [NSMutableArray arrayWithCapacity:((NSArray *)value).count];

                    if (descriptor.protocol.length)
                    {
                        Class aClass= NSClassFromString(descriptor.protocol);
                        if ([aClass isSubclassOfClass:[JsonSerializableObject class]])
                        {
                            NSArray *array= [value copy];
                            for (id item in array)
                            {
                                if ([item isKindOfClass:[NSDictionary class]])
                                {
                                    id obj= [[aClass alloc] init];
                                    [self importDictionary:item toObject:obj];
                                    if (obj)
                                        [mutableArray addObject:obj];
                                }
                                else
                                {
                                    @throw [NSException exceptionWithName:@"Deserialization type not allowed"
                                                                   reason:[NSString stringWithFormat:@"item in array %@.%@ is not kind of NSDictionary.", [object class], descriptor.propertyMappingKey]
                                                                 userInfo:nil];
                                }
                            }
                        }
                        else
                            [mutableArray addObjectsFromArray:value];
                    }
                    else
                        [mutableArray addObjectsFromArray:value];

                    if (descriptor.isMutable)
                        [object performSelector:@selector(setValue:forKey:) withObject:mutableArray withObject:descriptor.propertyName];
                    else
                        [object performSelector:@selector(setValue:forKey:) withObject:[NSArray arrayWithArray:mutableArray] withObject:descriptor.propertyName];
                }
                else if ([descriptor.type isSubclassOfClass:[NSDictionary class]])
                {
                    //处理字典
                    if (descriptor.isMutable)
                        [object performSelector:@selector(setValue:forKey:) withObject:[NSMutableDictionary dictionaryWithDictionary:value] withObject:descriptor.propertyName];
                    else
                        [object performSelector:@selector(setValue:forKey:) withObject:value withObject:descriptor.propertyName];
                }
                else if ([descriptor.type isSubclassOfClass:[NSString class]])
                {
                    NSString *strValue=nil;
                    if ([value isKindOfClass:[NSNumber class]])
                    {
                        strValue=((NSNumber *)value).stringValue;
                    }
                    else
                        strValue=value;
                    //处理String
                    if (descriptor.isMutable)
                        [object performSelector:@selector(setValue:forKey:) withObject:[NSMutableString stringWithString:strValue] withObject:descriptor.propertyName];
                    else
                        [object performSelector:@selector(setValue:forKey:) withObject:strValue withObject:descriptor.propertyName];

                }

            }
            else if ([descriptor.type isSubclassOfClass:[JsonSerializableObject class]])
            {
                id obj= [[descriptor.type alloc] init];
                [self importDictionary:value toObject:obj];
                if (obj)
                    [object performSelector:@selector(setValue:forKey:) withObject:obj withObject:descriptor.propertyName];
            }

        }
    }
}


- (NSDictionary *)inspectPropertiesForObject:(id)object
{
    if (![object isKindOfClass:[JsonSerializableObject class]])
        return nil;

    NSString *className = NSStringFromClass([object class]);
    NSDictionary *propertyDict = [self.classPropertyMappingCache objectForKey:className];
    if (propertyDict)
        return propertyDict;

    NSMutableDictionary *classProperties = [NSMutableDictionary dictionary];
    //查询属性列表

    Class class= [object class];

    NSScanner* scanner = nil;
    NSString* propertyType = nil;

    while (class !=[JsonSerializableObject class])
    {
        //检索当前类型的属性列表
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        typeof(class) instanceOfClass=object;
        NSDictionary *keyMappingTable= [instanceOfClass performSelector:@selector(keyMappingTable)]; //获取映射字典

        for (NSUInteger i=0;i<propertyCount;i++)
        {
            PropertyDescriptor *descriptor = [[PropertyDescriptor alloc] init];

            //获取property Name
            objc_property_t propertyT = properties[i];
            const char *propertyName = property_getName(propertyT);
            descriptor.propertyName = @(propertyName);
            descriptor.propertyMappingKey= [keyMappingTable objectForKey:descriptor.propertyName];
            if (descriptor.propertyMappingKey.length==0)
                descriptor.propertyMappingKey=descriptor.propertyName;

            if ([classProperties objectForKey:descriptor.propertyName])//子类的属性将覆盖父类属性
                continue;

            //获取propery attributes

            const char *attrs = property_getAttributes(propertyT);
            NSString *propertyAttributes = @(attrs);
            NSArray *attributeItems = [propertyAttributes componentsSeparatedByString:@","];

            //忽略只读属性
            if ([attributeItems containsObject:@"R"])
                continue; //to next property

            scanner = [NSScanner scannerWithString:propertyAttributes];

            [scanner scanUpToString:@"T" intoString:nil];
            [scanner scanString:@"T" intoString:nil];

            //判断property是否为某类型实例
            if ([scanner scanString:@"@\"" intoString:&propertyType])
            {
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&propertyType];

                descriptor.type = NSClassFromString(propertyType);
                descriptor.isMutable = ([propertyType rangeOfString:@"Mutable"].location != NSNotFound);
                descriptor.isSystemCopyableType = [systemCopyableTypes containsObject:descriptor.type];

                //读取protocol
                while ([scanner scanString:@"<" intoString:NULL])
                {
                    NSString* protocolName = nil;

                    [scanner scanUpToString:@">" intoString: &protocolName];

                    if([protocolName isEqualToString:@"Ignore"])
                        descriptor = nil;
                    else
                        descriptor.protocol = protocolName;

                    [scanner scanString:@">" intoString:NULL];
                }

            }
            else
            {
                //the property contains a primitive data type
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@","] intoString:&propertyType];

                if (![systemPrimitiveTypes objectForKey:propertyType])
                {
                    @throw [NSException exceptionWithName:@"Serialization type not allowed"
                                                   reason:[NSString stringWithFormat:@"Property type of %@.%@ is not supported for serialization.", [object class], descriptor.propertyName]
                                                 userInfo:nil];
                }
                else
                    descriptor.isPrimitive= YES;

            }

            if (descriptor)
                [classProperties setObject:descriptor forKey:descriptor.propertyName];
        }

        free(properties);

        class = [class superclass];
    }

    [self.classPropertyMappingCache setObject:classProperties forKey:className];

    return classProperties;
}


@end