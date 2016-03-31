//
// Created by fengshuai on 15/11/1.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NaviServiceItem : JsonSerializableObject
@property(nonatomic, copy) NSString * platform;
@property(nonatomic, copy) NSString * encode;
@property(nonatomic, copy) NSString * query;
@property(nonatomic, copy) NSString * smsr;
@property(nonatomic, copy) NSString * nsmsr;
@property(nonatomic, copy) NSString * shorttimeout;
@property(nonatomic, copy) NSString * ver;
@property(nonatomic, copy) NSString * longtimeout;
@property(nonatomic, copy) NSString * upload;
@property(nonatomic, copy) NSString * message;
@property(nonatomic, copy) NSString * suburls;
@property(nonatomic, copy) NSString * distfac;
@property(nonatomic, copy) NSString * sync;
@property(nonatomic, copy) NSString * login;
@property(nonatomic, copy) NSString * logintype;
@property(nonatomic, copy) NSString * salt;
@property(nonatomic, copy) NSString * dver;
@end

@interface NaviService:NSObject

- (void)startServiceWithBlock:(void(^)(NaviServiceItem *retItem, NSError *error))serviceBlock;


@end