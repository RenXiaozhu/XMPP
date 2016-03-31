//
// Created by fengshuai on 15/2/28.
// Copyright (c) 2015 8f8. All rights reserved.
//

#import <objc/runtime.h>
#import "NetworkServiceBase.h"
#import "AFHTTPRequestOperation.h"
#import "SerializationHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "NetworkErrorHelper.h"
#import "GlobalConfiguration.h"
#import "ServiceDataPacker.h"
#import "Reachability.h"
#import "NetworkResponse.h"
#import "NaviService.h"
//#import "LocalConfigData.h"
//#import "AppContext.h"

static NSDictionary *_servicePath;

@interface NetworkServiceBase ()
//网络链接对象
@property(nonatomic, strong) AFHTTPRequestOperation *networkOperation;
@end

@implementation NetworkServiceBase
{
    NSString *_methodName;
    Class _responseType;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        self.grp = [AppContext sharedInstance].configuration.grp;
//        self.ver = [AppContext appVersion];
//        self.platform = [AppContext sharedInstance].configuration.platform;
//        self.imei = [[UIDevice currentDevice] uniqueID];
//        self.src = [AppContext sharedInstance].configuration.src;
//        self.lang = [[NSLocale preferredLanguages] firstObject];
////        self.userid= [AppContext sharedInstance].loginUserID;
////        self.token= [AppContext sharedInstance].userToken;
//        self.userid= [LocalConfigData shareInstance].localConfigSaveUserAccountNameAndappKey.userid;
//        self.token= [LocalConfigData shareInstance].localConfigSaveUserAccountNameAndappKey.token;
    }

    return self;
}

- (NSString *)prepareRequestUrl:(ERequstType)requstType
{
    NSString *url= nil;
    switch (requstType)
    {
        case ERequestTypeGet:
            url=self.urlString;
            if ([url length]==0)
//                url= [[AppContext sharedInstance].naviConfiguration.query stringWithTrimWhiteSpcace];
            break;
        case ERequestTypePost:
            url=self.urlString;
            if ([url length]==0)
//                url= [[AppContext sharedInstance].naviConfiguration.upload stringWithTrimWhiteSpcace];
            break;
        default:
            break;
    }
    return url;
}

- (ServiceDataPacker *)prepareDataPacker
{
    ServiceDataPacker * packer =[[ServiceDataPacker alloc] init];
//    packer.salt = [AppContext sharedInstance].naviConfiguration.salt;
    return packer;
}


- (UInt16)serviceType
{
    NSString *serviceTypeName= NSStringFromClass([self class]);
    // "YUNxxxService" 截取中间的type
    UInt32 typeLength= [serviceTypeName length]-10;//"YUN"+"Service"=10个字符
    NSString *serviceTypeNum= [serviceTypeName substringWithRange:NSMakeRange(3, typeLength)];

    int serviceType=[serviceTypeNum intValue];
    if(serviceType)
        return (UInt16)serviceType;
    else
        @throw [NSException exceptionWithName:@"Invalid Service Type" reason:@"Invalid Service Type" userInfo:nil];
}


- (void)startGetForResponseType:(Class)responseType andBlock:(void (^)(id result, NSError *error))finishBlock
{
    [self.networkOperation cancel];

    if(responseType)
        _responseType = responseType;

    self.urlString= [self prepareRequestUrl:ERequestTypeGet];

    ServiceDataPacker *packer = [self prepareDataPacker];


    NSDictionary *jsonDict = [self composeParams];
    NSString *json= [jsonDict JSONString];

    DDLogVerbose(@"Service %i Request:%@", [self serviceType], json);

    NSString *urlString = [NSString stringWithFormat:@"%@?type=%d&info=%@",
                                                     self.urlString,
                                                     [self serviceType],
                                                     [packer packStringWithZip:json]];

    DDLogVerbose(@"Service %i Request URL:%@", [self serviceType],urlString);

    UInt16 serviceType= [self serviceType];

    if(![[Reachability reachabilityForInternetConnection] isReachable])
    {
        DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, NSLocalizedString(@"common_string_remind_network_error", nil));
        NSError *error0=[NSError errorWithDomain:@"NO_NETWORK" code:kServiceErrorCode userInfo:nil];
        if (finishBlock)
            finishBlock(nil,error0);
        return;
    }
    
//    @weakify(self);
//    self.networkOperation= [[AppContext sharedInstance].networkEngine GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @strongify(self);
//
//        UInt16 type = 0;
//        UInt32 errorCode = 0;
//        NSData *contentData = nil;
//        id file= nil;
//
//        [packer getResponseInfo:operation.responseData type:&type errorCode:&errorCode content:&contentData file:&file];
//        if (type == serviceType && (errorCode == 0 || errorCode  == serviceType*1000 ) && contentData)
//        {
//            NSData *parsedData = [packer unpackDataWithUnzip:contentData];
//            NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
//            DDLogVerbose(@"Service %d Response: %@", serviceType, responseString);
//            id result = [self composeResult:[responseString objectFromJSONString] attachedFile:file];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (finishBlock)
//                    finishBlock(result, nil);
//            });
//        }
//        else
//        {
//            NSDictionary *userInfo= nil;
//            if(contentData)
//            {
//                NSData *parsedData = [packer unpackDataWithUnzip:contentData];
//                NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
//                DDLogVerbose(@"Service %d with error Response: %@", serviceType, responseString);
//                userInfo= [responseString objectFromJSONString];
//            }
//            if (!userInfo)
//                userInfo = [NSDictionary dictionary];
//
//            NSError *error2=[NSError errorWithDomain:@"WCService" code:(int32_t)(errorCode) userInfo:userInfo];
//
//            DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (finishBlock)
//                    finishBlock(nil, error2);
//            });
//        }
//        self.networkOperation= nil;
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        @strongify(self);
//
//        DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error.code, [error localizedDescription]);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (finishBlock)
//                finishBlock(nil, error);
//        });
//        self.networkOperation=nil;
//    }];
//
}

- (void)startGetWithBlock:(void (^)(id result, NSError *error))finishBlock
{
    [self startGetForResponseType:nil andBlock:finishBlock];
}


- (void)startPostForResponseType:(Class)responseType finish:(void (^)(id result, NSError *error))finishBlock
                   progressBlock:(void (^)(float progress))progressBlock;
{
    [self.networkOperation cancel];

    if(responseType)
        _responseType = responseType;
//
//    AFHTTPRequestOperationManager *manager = [AppContext sharedInstance].networkEngine;
//
//    self.urlString= [self prepareRequestUrl:ERequestTypePost];
//
//    ServiceDataPacker *packer = [self prepareDataPacker];
//    NSDictionary *jsonDict = [self composeParams];
//
//    DDLogVerbose(@"Service %i Post:%@", [self serviceType], [jsonDict JSONString]);
//
//    NSData *jsonData = [jsonDict JSONData];
//
//    UInt16 serviceType=[self serviceType];
//
//    if(![[Reachability reachabilityForInternetConnection] isReachable])
//    {
//        DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,kServiceErrorCode, @"断网");
//        NSError *error0=[NSError errorWithDomain:@"NO_NETWORK" code:kServiceErrorCode userInfo:nil];
//        if (finishBlock)
//            finishBlock(nil,error0);
//        return;
//    }
//
//    NSData *parckedData= nil;
//    if (self.uploadFileData)
//        parckedData=[packer generatePost:[packer packDataWithZip:jsonData] forType:[self serviceType]
//                                withFile:[packer packData:self.uploadFileData]];
//    else
//        parckedData=[packer generatePost:[packer packDataWithZip:jsonData] forType:[self serviceType]];
//
//    @weakify(self);
//    self.networkOperation=[manager POST:self.urlString parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:parckedData
//                                    name:@"upload"
//                                fileName:([self.uploadFileName length]?self.uploadFileName:@"file")
//                                mimeType:@"application/octet-stream"];
//
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        @strongify(self);
//
//        UInt16 type = 0;
//        UInt32 errorCode = 0;
//        NSData *contentData = nil;
//        NSData *file= nil;
//        [packer getResponseInfo:operation.responseData type:&type errorCode:&errorCode content:&contentData file:&file];
//        if (type == serviceType &&  (errorCode == 0 || errorCode  == serviceType*1000 ) && contentData)
//        {
//            NSData *parsedData = [packer unpackDataWithUnzip:contentData];
//            NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
//            DDLogVerbose(@"%d Service Response: %@", serviceType, responseString);
//            id result = [self composeResult:[responseString objectFromJSONString] attachedFile:file];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (finishBlock)
//                    finishBlock(result, nil);
//            });
//        }
//        else
//        {
//            NSDictionary *userInfo= nil;
//            if(contentData)
//            {
//                NSData *parsedData = [packer unpackDataWithUnzip:contentData];
//                NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
//                DDLogVerbose(@"Service %d with error Response: %@", serviceType, responseString);
//                userInfo= [responseString objectFromJSONString];
//            }
//            if (!userInfo)
//                userInfo = [NSDictionary dictionary];
//
//            NSError *error2=[NSError errorWithDomain:@"WCService" code:(int32_t)errorCode userInfo:userInfo];
//            DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error2.code, [error2 localizedDescription]);
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (finishBlock)
//                    finishBlock(nil, error2);
//            });
//        }
//        self.networkOperation= nil;
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        @strongify(self);
//        DDLogError(@"%i Service Error. ErrorCode: %i. Error Description:%@", serviceType,(int)error.code, [error localizedDescription]);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (finishBlock)
//                finishBlock(nil, error);
//        });
//        self.networkOperation= nil;
//    }];
//
//    [self.networkOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long int totalBytesWritten, long long int totalBytesExpectedToWrite) {
//        if (progressBlock)
//            progressBlock((float)(totalBytesWritten/(double)totalBytesExpectedToWrite));
//    }];
}

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock
{
    [self startPostForResponseType:nil finish:finishBlock progressBlock:nil];
}

- (void)startPostWithBlock:(void (^)(id result, NSError *error))finishBlock progressBlock:(void (^)(float progress))progressBlock
{
    [self startPostForResponseType:nil finish:finishBlock progressBlock:progressBlock];
}


- (id)composeResult:(NSDictionary *)dictionary attachedFile:(NSData *)file
{
    id result=nil;
    if([[self getResponseType] isSubclassOfClass:[NetworkResponse class]])
    {
        result= [[_responseType alloc] initWithDictionary:dictionary];
        ((NetworkResponse *)result).attachedFile=file;
    }
    else
    {
        result=dictionary;
    }
    return result;
}

-(Class)getResponseType
{
    if (_responseType)
        return _responseType;

    uint protocolCount=0;
    Protocol*__unsafe_unretained*protocols= class_copyProtocolList([self class],&protocolCount);
    if (protocolCount)
    {
        for (int i = 0; i < protocolCount; ++i)
        {
            Protocol *aProtocol=protocols[i];
            NSString *typeName= NSStringFromProtocol(aProtocol);
            Class aClass= NSClassFromString(typeName);
            if ([aClass isSubclassOfClass:[JsonSerializableObject class]])
            {
                _responseType=aClass;
                break;
            }
        }
    }

    free(protocols);
    return _responseType;
}

- (NSMutableDictionary *)composeParams
{
    return [NSMutableDictionary dictionaryWithDictionary:[self serializeToDictionary]];
}


- (void)cancel
{
    [self.networkOperation cancel];
}

- (BOOL)isRunning
{
    return self.networkOperation.isExecuting;
}

#pragma mark -诊断方法

- (void)dealloc
{
    DDLogVerbose(@"Finalize Network Service:%@", [self debugDescription]);
    [self cancel];
}

@end