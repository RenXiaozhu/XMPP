//
// Created by JOY on 14-8-4.
// Copyright (c) 2014 JOY. All rights reserved.


#import <Foundation/Foundation.h>


@interface NetworkErrorHelper : NSObject

+ (NSError *)lookupErrorByErrorCode:(NSInteger)errorCode;

+ (NSString *)lookupResultByServiceName:(NSString *)servicename andResultStr:(NSString *)resultStr;

+(NSString *)lookupErrorDiscByErrorCode:(NSInteger)errorCode;

@end