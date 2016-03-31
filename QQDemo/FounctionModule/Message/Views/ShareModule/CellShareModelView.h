//
//  CellShareModelView.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/30.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareContentModel.h"
#import "PublicFile.h"

@interface CellShareModelView : UIView
{

    
    UIImageView *shareImg;
    UIButton *playerBtn;
    UILabel *shareTitleLable;
    UILabel *shareContentLable;
    
}


//分享图片
@property (nonatomic,retain) UIImageView *shareImg;
//播放按钮
@property (nonatomic,retain) UIButton *playerBtn;
//分享标题
@property (nonatomic,retain) UILabel *shareTitleLable;
//分享内容
@property (nonatomic,retain) UILabel *shareContentLable;


- (id)initWithFrame:(CGRect)frame contentUrl:(NSString *)contentUrl;

- (id)initWithFrame:(CGRect)frame shareModel:(ShareContentModel *)model;

@end
