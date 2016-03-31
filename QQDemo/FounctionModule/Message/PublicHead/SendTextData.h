//
//  SendTextData.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/30.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellShareModelView.h"

@interface SendTextData : NSObject

@property (nonatomic,retain) NSString *textData;

@property (nonatomic,retain) UIImageView *SendImg;

@property (nonatomic,retain) CellShareModelView *shareView;


@end
