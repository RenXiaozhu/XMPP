//
// Created by fengshuai on 14-8-7.
// Copyright (c) 2014 fengshuai. All rights reserved.


#import <Foundation/Foundation.h>


@interface PropertyDescriptor : NSObject

@property(nonatomic, copy) NSString *propertyName;

@property(nonatomic, copy) NSString *propertyMappingKey;

@property(nonatomic, copy) NSString *protocol;

@property(nonatomic, assign) Class type;//属性类

@property(nonatomic, assign) BOOL isPrimitive;//简单类型, NSNumber, NSString, Enum

@property(nonatomic, assign) BOOL isMutable;//NSMutableArray或NSMutableDictionary

@property(nonatomic, assign) BOOL isSystemCopyableType;//标准Json类型,array,dictionary等

@end