//
//  RootViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/11.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "RootViewController.h"
#import "UIColor+_16ToRGB.h"
@implementation RootViewController
@synthesize tView=_tView;
@synthesize errorLoad;
@synthesize reloadButton;
@synthesize myActivityIndicatorView;
@synthesize loadingView;


- (id)init
{
    self = [super init];
    if (self) {
        DDLogInfo(@"----");
    }
    return self;
}

- (void)initValuesWithName:(NSDictionary *)dictVaule
                   BGColor:(UIColor *)color
       NavgationBarBgColor:(NSString *)imgName
{

        if (self.navigationController == nil)
        {
            self.title = [dictVaule objectForKey:@"name"];
            self.view.backgroundColor = color;
        }
        else
        {
            [self.view setBackgroundColor:color];
            self.navigationController.navigationBar.topItem.title = [dictVaule
                                                                     objectForKey:@"name"];
            self.navigationItem.backBarButtonItem = nil;
            [self.navigationItem setHidesBackButton:YES];
            self.navigationController.navigationItem.backBarButtonItem = nil;
            
            UIView *emptyView = [[UIView alloc] init];;
            UIBarButtonItem *emptyButton = [[UIBarButtonItem alloc] initWithCustomView:emptyView];
            [self.navigationItem setLeftBarButtonItem:emptyButton animated:YES];
            
            if ([imgName hasPrefix:@"#"])
            {
                [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithHexString:imgName]];
            }
            else
            {
                if (![imgName isEqualToString:@""]&&imgName != nil) {
                    UIImage *img  = [[UIImage imageNamed:imgName] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
                    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
                    {
                        //if iOS 5.0 and later
                        [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
                    }
                    else
                    {
                        self.navigationController.navigationBar.layer.contents = (id)img.CGImage;
                    }

                }
                
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:[[dictVaule valueForKey:@"size"] floatValue]],NSFontAttributeName,[dictVaule valueForKey:@"color"],NSForegroundColorAttributeName, nil];
                
                self.navigationController.navigationBar.titleTextAttributes=dict;
                
            }
            
        }

}


- (BOOL)isConnect
{
//    NSString *urlString = @"http://www.baidu.com";

    
    return YES;
}


- (void)initViews
{
    
}


//- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    
//    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
//    NSLog(@"willTransitionToTraitCollection");
//}

//- (void)didLoadInitView
//{
//
//}

//重载数据
- (void)reloadNewsData
{

}

//显示提示框
- (void)showErrorToast:(CGRect)rect withStr:(NSString *)str
{

//    UILabel *lable=[[UILabel alloc]initWithFrame:rect];
    
    
    
    
    
}

//显示加载失败视图
- (void)showReloadView:(BOOL) DataOrEvent
{

}


- (void)hiddenReloadView
{

}


- (void)startMyActivityIndicatorView
{

}


- (void)stopAllActivityIndicatorView
{

}

@end
