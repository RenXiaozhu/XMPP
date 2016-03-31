//
// Created by fengshuai on 15/10/24.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TLVSerializationHelper : NSObject

+ (instancetype)sharedInstance;

- (void)importData:(NSData *)data  toObject:(id)object;

- (NSArray *)generateArrayFromData:(NSData *)data andClass:(Class)type;

- (NSData *)serializeFromObject:(id)object;

@end