//
// Created by fengshuai on 15/11/12.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import "NSDate+Additions.h"


@implementation NSDate (Additions)

+(NSDateFormatter*)getDBDateFormat
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return format;
}

+(NSString*)stringWithDate:(NSDate*)date
{
    NSDateFormatter* formatter = [self getDBDateFormat];
    NSString* datestr = [formatter stringFromDate:date];
    return datestr;
}

+(NSDate *)dateWithString:(NSString *)str
{
    NSDateFormatter* formatter =[self getDBDateFormat];
    NSDate* date = [formatter dateFromString:str];
    return date;
}

@end