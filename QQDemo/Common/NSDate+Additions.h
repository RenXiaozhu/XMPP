//
// Created by fengshuai on 15/11/12.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

//把Date 转换成String
+ (NSString *)stringWithDate:(NSDate *)date;

//把String 转换成Date
+ (NSDate *)dateWithString:(NSString *)str;

@end