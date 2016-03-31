//
// Created by fengshuai on 15/11/4.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (TLVConverter)

-(NSString *)toPlainString;

-(NSString *)toVersionString;

-(NSDate *)toDate;

//双字节数据转时间戳
-(int)toTimeStampHHmmss;

+(instancetype)dataFromDate:(NSDate *)date;

+(instancetype)dataFromActivityID:(NSString *)activityID;

-(NSString *)toActivityID;

//多字节转int
-(uint32_t)toUInt32;

@end