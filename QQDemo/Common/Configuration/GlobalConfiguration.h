//
// Created by JOY on 14-8-4.
// Copyright (c) 2014 JOY. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalConfiguration : JsonSerializableObject

@property(nonatomic, copy) NSString *grp;
@property(nonatomic, copy) NSString *platform;
@property(nonatomic, copy) NSString *src;
@property(nonatomic, copy) NSString *naviURL;
@property(nonatomic, copy) NSString *expUrl;
@property(nonatomic, copy) NSString *warmupUrl;
@property(nonatomic, copy) NSString *storeUrl;
@property(nonatomic, copy) NSString *liningUrl;
@property(nonatomic, copy) NSString *naviURLTest;
@property(nonatomic, assign) BOOL isTest;

@end