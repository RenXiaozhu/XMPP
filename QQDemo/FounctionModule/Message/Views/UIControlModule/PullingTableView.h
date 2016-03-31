//
//  MytableView.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/13.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterDropLoadingView.h"

@interface PullingTableView : UITableView<UIScrollViewDelegate>
{
    WaterDropLoadingView *upLoadingView;
    UIActivityIndicatorView * DownActivity;
    UIView * downTipView;
    UILabel * DowntipLable;
    void(^pullingRefreshBlock)(void);
    void(^downReloadDataBlock)(void);
}
@property (nonatomic,retain) WaterDropLoadingView *upLoadingView;
@property (nonatomic,retain) UIActivityIndicatorView * DownActivity;
@property (nonatomic,retain) UIView * downTipView;
@property (nonatomic,retain) UILabel * DowntipLable;
@property (nonatomic,copy)   void(^pullingRefreshBlock)(void);
@property (nonatomic,copy)   void(^downReloadDataBlock)(void);


- (instancetype)initPullingTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)style pullingRefreshBlock:(void (^)(void))pullingRefreshBlock downReloadDataBlock:(void (^)(void))downReloadDataBlock;



- (void)restoreTableView;


- (void)updateLoadingStateWithState:(LoadingState)state;

@end
