//
// Created by fengshuai on 14-8-21.
// Copyright (c) 2014 fengshuai. All rights reserved.


#import "SerializationHelper.h"

@implementation JsonSerializableObject

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self)
    {
        [[SerializationHelper sharedInstance] importDictionary:dictionary toObject:self];
    }

    return self;
}

- (NSDictionary *)serializeToDictionary
{
    return [[SerializationHelper sharedInstance] serializeFromObject:self];
}

- (NSString *)serializeToString
{
    NSDictionary *dictionary= [self serializeToDictionary];
    return [dictionary JSONString];
}

- (void)updateModelValuesWithDict:(NSDictionary *)dict
{
    [[SerializationHelper sharedInstance] importDictionary:dict toObject:self];
}

- (NSDictionary *)keyMappingTable
{
    return nil;
}

@end