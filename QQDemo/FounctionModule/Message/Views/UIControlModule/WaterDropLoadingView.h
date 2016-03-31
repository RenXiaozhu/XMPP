//
//  WaterDropLoadingView.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/7.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicFile.h"

@interface WaterDropLoadingView : UIView
{
    UIImageView *refreshImg;
    UIActivityIndicatorView *activityView;
    LoadingState state;
    UILabel *tipLabel;
    void (^changTableViewStateBlock)(LoadingState state);
}


@property (nonatomic,retain) UIImageView *refreshImg;
@property (nonatomic,retain) UIActivityIndicatorView *activityView;
@property (nonatomic,assign) LoadingState state;
@property (nonatomic,retain) UILabel *tipLabel;
@property (nonatomic,copy)   void (^changTableViewStateBlock)(LoadingState state);

- (id)initWithFrame:(CGRect)frame refreshImg:(NSString *)refreshImg;

- (id)initDefaultViewWithFrame:(CGRect)frame;

- (void)drawViewWithOffset:(CGFloat)height;

- (void)upDateLoadingStateWithState:(LoadingState)loadingState;

@end
