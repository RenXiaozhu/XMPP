//
// Created by fengshuai on 15/11/1.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import "NaviService.h"
#import "AFHTTPRequestOperation.h"
#import "ServiceDataPacker.h"
#import "AFHTTPRequestOperationManager.h"
#import "GlobalConfiguration.h"
//#import "AppContext.h"

@implementation NaviServiceItem


@end

@interface NaviService()

@property(nonatomic, strong) AFHTTPRequestOperation *networkOperation;

@end

@implementation NaviService
{

}

- (void)startServiceWithBlock:(void (^)(NaviServiceItem *retItem, NSError *error))serviceBlock
{
    [self.networkOperation cancel];

    ServiceDataPacker *packer = [ServiceDataPacker alloc];
    packer.salt = nil;
//
//    NSString *url = [AppContext sharedInstance].configuration.isTest?[AppContext sharedInstance].configuration.naviURLTest:[AppContext sharedInstance].configuration.naviURL;
//    
//    @weakify(self);
//    
//    self.networkOperation = [[[AppContext sharedInstance] networkEngine]
//                             GET:url
//                             parameters:nil
//                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        @strongify(self);
//
//        NSData *parsedData = [packer unpackDataWithUnzip:operation.responseData];
//        NSString *responseString = [[NSString alloc] initWithData:parsedData encoding:NSUTF8StringEncoding];
//        NSLog(@"Navi Service : %@", responseString);
//
//        NaviServiceItem *item = [[NaviServiceItem alloc] initWithDictionary:[responseString objectFromJSONString]];
//        if (serviceBlock)
//            serviceBlock(item,nil);
//        self.networkOperation= nil;
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        @strongify(self);
//        if (serviceBlock)
//            serviceBlock(nil,error);
//        self.networkOperation= nil;
//    }];

}

- (void)dealloc
{
    [self.networkOperation cancel];
}


@end