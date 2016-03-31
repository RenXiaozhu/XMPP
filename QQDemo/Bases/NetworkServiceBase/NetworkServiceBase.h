//
// Created by fengshuai on 15/5/12.
// Copyright (c) 2015 com.8f8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServiceDataPacker;

#define kServiceErrorCode (999)//断网


typedef enum
{
    ERequestTypeGet = 0,
    ERequestTypePost
} ERequstType;

@interface NetworkServiceBase : JsonSerializableObject

@property(nonatomic, copy) NSString *userid;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *grp;
@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *platform;
@property(nonatomic, copy) NSString *imei;
@property(nonatomic, copy) NSString *src;
@property(nonatomic, copy) NSString *lang;
@property(nonatomic, copy) NSString <Ignore> *urlString;
@property(nonatomic, copy) NSString *uploadFileName;
@property(nonatomic, strong) NSData <Ignore> *uploadFileData;

//启动Get调用
- (void)startGetForResponseType:(Class)responseType andBlock:(void (^)(id result, NSError *error))finishBlock;

- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock;

//启动Post调用
- (void)startPostForResponseType:(Class)responseType finish:(void (^)(id result, NSError *error))finishBlock
                   progressBlock:(void (^)(float progress))progressBlock;

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock progressBlock:(void (^)(float progress))progressBlock;

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock;

//取消
- (void)cancel;

//运行状态
- (BOOL)isRunning;

//Methods for Overriden
- (NSString *)prepareRequestUrl:(ERequstType)requstType;

- (ServiceDataPacker *)prepareDataPacker;

//该方法一般不需要覆盖，但对401~410 除外
- (UInt16)serviceType;

//拼装请求参数
- (NSMutableDictionary *)composeParams;

//对返回字符串进行解析
- (id)composeResult:(NSDictionary *)dictionary attachedFile:(NSData *)file;

@end