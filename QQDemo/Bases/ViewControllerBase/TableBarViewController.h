//
//  TableBarViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/7.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableBarViewController : UITabBarController
- (instancetype)init;
@end



@interface UITabBarController (TableBarViewControllerSupport)
@property(nonatomic, retain, readonly) TableBarViewController *tableBarViewController;
@end

