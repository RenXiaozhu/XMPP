//
// Created by JOY on 14-8-4.
// Copyright (c) 2014 JOY. All rights reserved.


#import "NetworkErrorHelper.h"


@implementation NetworkErrorHelper

static NSDictionary *errorDictionary;

+ (void)initialize
{
    NSAssert([NetworkErrorHelper class] == self, @"Incorrect use of singleton : %@, %@", [NetworkErrorHelper class], [self class]);
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"errorCodeMappingTable" ofType:@"plist"];
    
    errorDictionary= [NSDictionary dictionaryWithContentsOfFile:filepath];
    
}


+(NSError *)lookupErrorByErrorCode:(NSInteger)errorCode
{
    NSError *error= nil;
    NSString *errorDescription= [errorDictionary valueForKey:@(errorCode).stringValue];
    if ([errorDescription length])
        error= [NSError errorWithDomain:@"YunDong.NetworkServiceError"
                                   code:errorCode
                               userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
    else
        
        error= [NSError errorWithDomain:@"YunDong.NetworkServiceError"
                                   code:errorCode
                               userInfo:@{NSLocalizedDescriptionKey:@"未知错误"}];

    return error;
    
}

+ (NSString *)lookupResultByServiceName:(NSString *)servicename andResultStr:(NSString *)resultStr {
    NSString *str = resultStr;

    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"errorCodeMappingTable" ofType:@"plist"];

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filepath];

    NSDictionary *resultDic = [dic objectForKey:servicename];

    if ([resultDic isKindOfClass:[NSDictionary class]] && [resultDic objectForKey:resultStr] != nil)
    {
        str = [resultDic objectForKey:resultStr];
    }

    return str;
}


+ (NSString *)lookupErrorDiscByErrorCode:(NSInteger)errorCode
{
    return  [errorDictionary valueForKey:@(errorCode).stringValue];
}

@end