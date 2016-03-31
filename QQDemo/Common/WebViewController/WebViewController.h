//
// Created by fengshuai on 16/2/27.
// Copyright (c) 2016 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebViewController : ViewControllerBase
@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) BOOL showShareAction;
@property(nonatomic, assign) BOOL appendUserId;

-(void)reload;

@end