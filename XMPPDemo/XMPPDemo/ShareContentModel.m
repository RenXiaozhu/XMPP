//
//  ShareContentModel.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/30.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "ShareContentModel.h"

@implementation ShareContentModel
@synthesize contentUrl;
@synthesize shareContent;
@synthesize shareImg;
@synthesize shareContentType;
@synthesize shareTitle;
@synthesize shareFrom;


- (void)dealloc
{
    [contentUrl release];
    [shareTitle release];
    [shareImg release];
    [shareContent release];
    [super dealloc];
}

@end
