//
// Created by fengshuai on 16/2/27.
// Copyright (c) 2016 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkResponse.h"
#import "NetworkServiceBase.h"

Generalize(YUD301ServiceResponse);
Generalize(AppUpgradeInfo);

@interface AppUpgradeInfo:JsonSerializableObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *fileurl;
@property(nonatomic, copy) NSString *version;
@property(nonatomic, copy) NSString *md5;
@property(nonatomic, copy) NSString *platform;
@property(nonatomic, copy) NSString *tips;
@end
@interface YUD301ServiceResponse:NetworkResponse
@property(nonatomic, strong) AppUpgradeInfo *appupgradeinfo;
@end
@interface YUD301Service : NetworkServiceBase<YUD301ServiceResponse>
@end