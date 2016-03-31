//
//  ShareContentModel.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/30.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicFile.h"

@interface ShareContentModel : NSObject
{
    NSString      *contentUrl;
    NSData        *shareImg;
    NSString      *shareTitle;
    ShareType      shareContentType;
    NSString      *shareContent;
    NSString      *shareFrom;
}

//分享内容的url
@property (nonatomic,retain) NSString      *contentUrl;
//分享图片
@property (nonatomic,retain) NSData        *shareImg;
//分享标题
@property (nonatomic,retain) NSString      *shareTitle;
//分享内容类型
@property (nonatomic,assign) ShareType     shareContentType;
//分享内容
@property (nonatomic,retain) NSString      *shareContent;
//分享类别
@property (nonatomic,retain) NSString      *shareFrom;
@end
