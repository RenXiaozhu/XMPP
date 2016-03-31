//
// Created by fengshuai on 15/11/4.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import "NSData+TLVConverter.h"


@implementation NSData (TLVConverter)
- (NSString *)toPlainString
{
    NSMutableString *mutableString= [NSMutableString string];

    Byte *bytes= self.bytes;
    for(NSUInteger i=0;i<self.length;i++)
    {
        [mutableString appendFormat:@"%x",bytes[i]];
    }

    return mutableString;
}

- (NSString *)toVersionString
{
    NSMutableString *mutableString= [NSMutableString string];

    Byte *bytes= self.bytes;
    for(NSUInteger i=0;i<self.length;i++)
    {
        [mutableString appendFormat:@"%i.",bytes[i]];
    }
    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length-1,1)];
    return mutableString;

}


- (NSDate *)toDate
{
    if (self.length!=14)
        return nil;

    Byte *bytes= self.bytes;

    NSMutableString *mutableString= [NSMutableString string];

    for(NSUInteger i=0;i<self.length;i++)
    {
        [mutableString appendFormat:@"%i",bytes[i]];
    }
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:mutableString];

    return date;
}

- (int)toTimeStampHHmmss
{
    if (self.length!=3)
        return 0;

    Byte *bytes = self.bytes;

    int time =  bytes[0] * 256*256 + bytes[1]*256 + bytes[2];

    return time;
}


+ (instancetype)dataFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *string=[dateFormatter stringFromDate:date];
    uint8_t *bytes=malloc(sizeof(uint8_t)*14);
    for(NSUInteger i=0;i<14;i++)
    {
        bytes[i]= (uint8_t)([string characterAtIndex:i]-0x30);
    }
    NSData *data= [NSData dataWithBytes:bytes length:14];
    free(bytes);
    return data;
}

+ (instancetype)dataFromActivityID:(NSString *)activityID
{
    if (activityID.length!=8)
        @throw [NSException exceptionWithName:@"invalid activity" reason:@"activityID的长度不对" userInfo:nil];

    NSMutableData *mutableData= [NSMutableData data];
    for(NSUInteger i=0;i<6;i++)
    {
        uint8_t byte=(uint8_t)[activityID characterAtIndex:i];
        byte-=48;//将日期数字进行转码
        [mutableData appendBytes:&byte length:1];
    }

    NSString *suffix= [activityID substringWithRange:NSMakeRange(6,2)];
    uint8_t suffixID = (uint8_t)strtoul([suffix UTF8String],0,16);
    [mutableData appendBytes:&suffixID length:1];
//    suffix= [activityID substringWithRange:NSMakeRange(7,1)];
//    suffixID = (uint8_t)strtoul([suffix UTF8String],0,16);
//    [mutableData appendBytes:&suffixID length:1];

    return mutableData;
}

- (NSString *)toActivityID
{
    if (self.length!=7)
        return nil;

    NSMutableString *mutableString= [NSMutableString string];

    Byte *bytes= self.bytes;
    for(NSUInteger i=0;i<self.length-1;i++)
    {
        [mutableString appendFormat:@"%x",bytes[i]];
    }

    [mutableString appendFormat:@"%02x",bytes[6]];

    return mutableString;
}


- (uint32_t)toUInt32
{
    if (self.length==0)
        return 0;

    Byte *bytes = self.bytes;

    uint32_t result=0;

    for(int i=0;i<self.length;i++)
        result+=bytes[i]<<8;

    return ntohs(result);
}


@end