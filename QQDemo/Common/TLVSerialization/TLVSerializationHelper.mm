//
// Created by fengshuai on 15/10/24.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <objc/runtime.h>
#import "TLVSerializationHelper.h"
#import "TLVPropertyDescriptor.h"
#import "CTLVPacket.h"
#import "TLVSerializableObject.h"

const uint8_t OBJECT_SEPERATOR=0x7c; //将'|'作为分隔符

@interface TLVSerializationHelper()
@property(nonatomic, strong) NSCache *classPropertyMappingCache;//记录已缓存的类型描述
@end

@implementation TLVSerializationHelper
{
    NSArray * _systemCopyableTypes;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.classPropertyMappingCache = [[NSCache alloc] init];
        [self.classPropertyMappingCache setName:@"yundongsports.serialization.mapping.cache"];
        _systemCopyableTypes = @[
                [NSString class],
                [NSArray class],
                [NSData class]
        ];
    }

    return self;
}


+ (instancetype)sharedInstance
{
    static TLVSerializationHelper *_instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)importData:(NSData *)data toObject:(id)object
{

    //根据类型结构赋值
    if (data== nil||![object isKindOfClass:[TLVSerializableObject class]])
        return;

    NSDictionary *classProperties = [self inspectPropertiesForObject:object];

    if ([classProperties count]==0)
        return;

    char *bytes=(char *)data.bytes;

    [self importData:bytes toObject:object andLen:data.length andClassProperties:classProperties];

}

- (NSArray *)generateArrayFromData:(NSData *)data andClass:(Class)type
{
    //根据类型结构赋值
    if (data== nil||![type isSubclassOfClass:[TLVSerializableObject class]])
        return nil;

    char *bytes=(char *)data.bytes;

    return [self generateArrayFromData:bytes withLen:data.length andClass:type];
}


-(NSArray *)generateArrayFromData:(char *)data withLen:(NSUInteger)len andClass:(Class)type
{
    CTLVPacket decoder(data,len);
    NSMutableArray *mutableArray= [NSMutableArray array];
    uint8_t tag,length=0;
    while(decoder.readInt(&tag))
    {
        decoder.readInt(&length);

        if (tag!=OBJECT_SEPERATOR)//检测分隔符'|'
        {
            decoder.skipReadPtr(length);
            continue;
        }

        char *subData=decoder.getReadPtr();
        id object= [[type alloc] init];
        NSDictionary *classProperties = [self inspectPropertiesForObject:object];
        if ([classProperties count]==0)
            return nil;
        [self importData:subData toObject:object andLen:length andClassProperties:classProperties];
        [mutableArray addObject:object];
        decoder.skipReadPtr(length);
    }

    return mutableArray;
}

- (void)importData:(char *)data
          toObject:(id)object
            andLen:(int)dataLen
            andClassProperties:(NSDictionary<NSString *,TLVPropertyDescriptor *> *)classProperties
{
    CTLVPacket decoder(data,(uint32_t)dataLen);

    uint8_t tag,length=0;

    while(decoder.readInt(&tag)&&decoder.readInt(&length))
    {
        if (length==0)
            continue;

        NSString *tagStr=@(tag).stringValue;
        TLVPropertyDescriptor *descriptor= classProperties[tagStr];
        if (descriptor==nil)
        {
            NSLog(@"没有找到类型描述符");
            decoder.skipReadPtr(length);
            continue;
        }

        if (descriptor.isPrimitive)//int
        {
            uint8_t value=0;
            decoder.readInt(&value);
            [object performSelector:@selector(setValue:forKey:) withObject:@(value) withObject:descriptor.propertyName];
        }
        else if (descriptor.isSystemCopyableType)
        {
            if ([descriptor.type isSubclassOfClass:[NSArray class]])
            {
                NSArray *array=nil;
                if (descriptor.protocol.length)
                {
                    Class aClass= NSClassFromString(descriptor.protocol);
                    if ([aClass isSubclassOfClass:[TLVSerializableObject class]])
                    {
                        //将Data切分为多个数据块
                        char *offset=decoder.getReadPtr();
                        array= [self generateArrayFromData:offset withLen:length andClass:aClass];
                        decoder.skipReadPtr(length);
                    }
                    else
                    {
                        NSLog(@"类型必须继承自TLVSerializableObject");
                        decoder.skipReadPtr(length);
                        continue;
                    }
                }
                else
                {
                    NSLog(@"无法获取泛型信息");
                    decoder.skipReadPtr(length);
                    continue;
                }

                if (descriptor.isMutable)
                    [object performSelector:@selector(setValue:forKey:) withObject:[NSMutableArray arrayWithArray:array] withObject:descriptor.propertyName];
                else
                    [object performSelector:@selector(setValue:forKey:) withObject:array withObject:descriptor.propertyName];
            }
            else if ([descriptor.type isSubclassOfClass:[NSDictionary class]])
            {
                NSLog(@"无法处理字典");
                decoder.skipReadPtr(length);
                continue;
            }
            else if ([descriptor.type isSubclassOfClass:[NSString class]])
            {
                char *cstr=(char*)malloc(sizeof(char)*length);
                memset(cstr,0,sizeof(char)*length);
                decoder.read(cstr,length);

                NSString *string= [NSString stringWithCString:cstr encoding:NSASCIIStringEncoding];

                free(cstr);
                //处理String
                if (descriptor.isMutable)
                    [object performSelector:@selector(setValue:forKey:) withObject:[NSMutableString stringWithString:string] withObject:descriptor.propertyName];
                else
                    [object performSelector:@selector(setValue:forKey:) withObject:string withObject:descriptor.propertyName];

            }
            else if ([descriptor.type isSubclassOfClass:[NSData class]])
            {
                char *cstr=(char*)malloc(sizeof(char)*length);
                memset(cstr,0,sizeof(char)*length);
                decoder.read(cstr,length);

                NSData *data1= [NSData dataWithBytes:cstr length:length];

                free(cstr);
                //处理String
                if (descriptor.isMutable)
                    [object performSelector:@selector(setValue:forKey:) withObject:[NSMutableData dataWithData:data1] withObject:descriptor.propertyName];
                else
                    [object performSelector:@selector(setValue:forKey:) withObject:data1 withObject:descriptor.propertyName];

            }
        }
        else if ([descriptor.type isSubclassOfClass:[TLVSerializableObject class]])
        {
            id obj= [[descriptor.type alloc] init];
            char *subData=decoder.getReadPtr();
            [self importData:subData toObject:obj andLen:(uint32_t)length andClassProperties:classProperties];
            if (obj)
                [object performSelector:@selector(setValue:forKey:) withObject:obj withObject:descriptor.propertyName];
        }
    }
}



- (NSData *)serializeFromObject:(id)object
{
    NSMutableData *mutableData= [NSMutableData data];

    NSDictionary *classProperties = [self inspectPropertiesForObject:object];

    if ([classProperties count]==0)
        return nil;

    for(TLVPropertyDescriptor *descriptor in classProperties.allValues)
    {
        if (descriptor.isPrimitive)
        {
            NSNumber *val= [object valueForKey:descriptor.propertyName];
            uint8_t value=(uint8_t)val.intValue;
            if (value==0)
                continue;

            uint8_t tag=(uint8_t)descriptor.tag.intValue;
            [mutableData appendBytes:&tag length:sizeof(uint8_t)];
            uint8_t len=1;
            [mutableData appendBytes:&len length:sizeof(uint8_t)];

            [mutableData appendBytes:&value length:sizeof(uint8_t)];
        }
        else if ([descriptor.type isSubclassOfClass:NSString.class])
        {
            NSString *string= [object valueForKey:descriptor.propertyName];
            if (string.length==0)
                continue;

            uint8_t tag=(uint8_t)descriptor.tag.intValue;
            [mutableData appendBytes:&tag length:sizeof(uint8_t)];

            NSData *strData= [string dataUsingEncoding:NSASCIIStringEncoding];
            uint8_t len=(uint8_t)strData.length;
            if (len>255)
            {
                @throw [NSException exceptionWithName:@"数据长度超限" reason:[NSString stringWithFormat:@"TLV中的L不能超过255,实际长度为%u",len] userInfo:nil];
            }
            [mutableData appendBytes:&len length:sizeof(uint8_t)];
            [mutableData appendBytes:strData.bytes length:strData.length];
        }
        else if ([descriptor.class isSubclassOfClass:TLVSerializableObject.class])
        {
            TLVSerializableObject *subObj= [object valueForKey:descriptor.propertyName];
            if (subObj==nil)
                continue;

            uint8_t tag=(uint8_t)descriptor.tag.intValue;
            [mutableData appendBytes:&tag length:sizeof(uint8_t)];

            NSData *subData= [self serializeFromObject:subObj];
            uint8_t len=(uint8_t)subData.length;
            if (len>255)
            {
                @throw [NSException exceptionWithName:@"数据长度超限" reason:[NSString stringWithFormat:@"TLV中的L不能超过255,实际长度为%u",len] userInfo:nil];
            }
            [mutableData appendBytes:&len length:sizeof(uint8_t)];
            [mutableData appendData:subData];
        }
        else if ([descriptor.type isSubclassOfClass:NSData.class])
        {
            NSData *data=[object valueForKey:descriptor.propertyName];;
            if (data==nil||data.length==0)
                continue;

            uint8_t tag=(uint8_t)descriptor.tag.intValue;
            [mutableData appendBytes:&tag length:sizeof(uint8_t)];

            uint8_t len=(uint8_t)data.length;
            if (len>255)
            {
                @throw [NSException exceptionWithName:@"数据长度超限" reason:[NSString stringWithFormat:@"TLV中的L不能超过255,实际长度为%u",len] userInfo:nil];
            }
            [mutableData appendBytes:&len length:sizeof(uint8_t)];
            [mutableData appendBytes:data.bytes length:data.length];
        }
        else if ([descriptor.type isSubclassOfClass:NSArray.class])
        {
            NSArray *subArray= [object valueForKey:descriptor.propertyName];
            if (subArray.count==0)
                continue;

            uint8_t tag=(uint8_t)descriptor.tag.intValue;
            [mutableData appendBytes:&tag length:sizeof(uint8_t)];

            uint32_t len=0;
            uint32_t index=mutableData.length;
            [mutableData appendBytes:&len length:sizeof(uint8_t)];
            for (TLVSerializableObject *subObj  in subArray)
            {
                NSData *subData= [self serializeFromObject:subObj];
                len+=subData.length+2;
                uint8_t tag_len[]={OBJECT_SEPERATOR,(uint8_t)subData.length};     //使用'|'号分隔列表
                [mutableData appendBytes:tag_len length:2];
                [mutableData appendData:subData];
            }
            if (len>255)
            {
                @throw [NSException exceptionWithName:@"数据长度超限" reason:[NSString stringWithFormat:@"TLV中的L不能超过255,实际长度为%u",len] userInfo:nil];
            }
            else//将真实长度写入TLV中的L
                [mutableData replaceBytesInRange:NSMakeRange(index,1) withBytes:&len length:sizeof(uint8_t)];
        }
    }

    return mutableData;
}


- (NSDictionary<NSString *,TLVPropertyDescriptor *> *)inspectPropertiesForObject:(id)object
{
    if (![object isKindOfClass:[TLVSerializableObject class]])
        return nil;

    NSString *className = NSStringFromClass([object class]);
    NSDictionary *propertyDict = [self.classPropertyMappingCache objectForKey:className];
    if (propertyDict)
        return propertyDict;

    NSMutableDictionary *classProperties = [NSMutableDictionary dictionary];
    //查询属性列表

    Class theClass= [object class];

    NSScanner* scanner = nil;
    NSString* propertyType = nil;

    while (theClass !=[TLVSerializableObject class])
    {
        //检索当前类型的属性列表
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);

        for (NSUInteger i=0;i<propertyCount;i++)
        {
            TLVPropertyDescriptor *descriptor = [[TLVPropertyDescriptor alloc] init];

            //获取property Name
            objc_property_t propertyT = properties[i];
            const char *propertyName = property_getName(propertyT);
            descriptor.propertyName = @(propertyName);

            if ([classProperties objectForKey:descriptor.propertyName])//子类的属性将覆盖父类属性
                continue;

            //拆分下划线右侧的tag
            NSArray <NSString *> *array=[descriptor.propertyName componentsSeparatedByString:@"_"];
            if (array.count==2)
            {
                NSString *tagStr= [NSString stringWithFormat:@"0x%@",array.lastObject.lowercaseString];
                uint8_t tag=(uint8_t)strtoul([tagStr UTF8String],0,16);
                descriptor.tag=@(tag).stringValue;
            }
            else
                continue;//不符合属性名编码规则,查找下一个

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
                descriptor.isSystemCopyableType = [_systemCopyableTypes containsObject:descriptor.type];


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

                if (![propertyType.lowercaseString isEqualToString:@"c"])//只支持char型
                {
                    @throw [NSException exceptionWithName:@"Serialization type not allowed"
                                                   reason:[NSString stringWithFormat:@"Property type of %@.%@ is not supported for serialization.", [object class], descriptor.propertyName]
                                                 userInfo:nil];
                }
                else
                    descriptor.isPrimitive= YES;

            }

            if (descriptor)
                [classProperties setObject:descriptor forKey:descriptor.tag];
        }

        free(properties);

        theClass = [theClass superclass];
    }

    [self.classPropertyMappingCache setObject:classProperties forKey:className];

    return classProperties;
}

@end