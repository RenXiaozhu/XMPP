//
//  BasicLoadingViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/28.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableBarViewController.h"
#import "BasicViewController.h"
#import "RootNavViewController.h"
#import "LeftToolViewController.h"
#import "RoghtToolViewController.h"

@interface BasicLoadingViewController : UIViewController
{
    CGPoint startPoint;
    CGPoint endPoint;
    LeftToolViewController *leftToolView;
    RoghtToolViewController *rightToolView;
    TableBarViewController *tableBarViewController;
}


@property (nonatomic,retain) LeftToolViewController *leftToolView;
@property (nonatomic,retain) RoghtToolViewController *rightToolView;
@property (nonatomic,retain) TableBarViewController *tableBarViewController;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;
@end
