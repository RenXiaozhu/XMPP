//
// Created by fengshuai on 14-8-7.
// Copyright (c) 2014 fengshuai. All rights reserved.


#import <Foundation/Foundation.h>

@class JsonSerializableObject;


@interface SerializationHelper : NSObject

+ (SerializationHelper *)sharedInstance;

- (NSDictionary *)serializeFromObject:(id)object;

- (void)importDictionary:(NSDictionary *)dictionary toObject:(id)object;


@end