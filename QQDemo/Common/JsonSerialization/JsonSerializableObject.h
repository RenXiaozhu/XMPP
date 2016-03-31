//
// Created by fengshuai on 14-8-21.
// Copyright (c) 2014 fengshuai. All rights reserved.


#import <Foundation/Foundation.h>


@interface JsonSerializableObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateModelValuesWithDict:(NSDictionary *)dict;

- (NSDictionary *)serializeToDictionary;

- (NSString *)serializeToString;

- (NSDictionary *)keyMappingTable;

@end