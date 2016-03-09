//
//  ChatListViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "ChatListViewController.h"
#import "UINavigationBar+Awesome.h"
#import "WaterDropLoadingView.h"
#import "UIView+ZXQuartz.h"
#import "ChatContentBaseViewController.h"

@interface ChatListViewController ()
{
    PullingTableView *rxzTableView;
}
@end

@implementation ChatListViewController


- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self.navigationController.navigationBar lt_setPurBackgroundColor:[UIColor colorWithRed:99/255.0 green:200/255.0 blue:249/255.0 alpha:1.0]];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    self.navigationItem.title = @"消息";
    self.navigationController.navigationBar.titleTextAttributes = dict1;
    [dict1 release];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.exclusiveTouch = YES;
    leftBtn.frame = CGRectMake(0, 0, 50, 25);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitle:@"个人" forState:UIControlStateNormal];
    leftBtn.titleLabel.textColor = [UIColor blackColor];
    [leftBtn addTarget:self action:@selector(showToolView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.exclusiveTouch = YES;
    rightBtn.frame = CGRectMake(0, 0, 50, 25);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.titleLabel.textColor = [UIColor blackColor];
    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showToolView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item1;
    [item1 release];
    
    
    rxzTableView = [[PullingTableView alloc]initPullingTableViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain pullingRefreshBlock:^{
        [self loadData];
    } downReloadDataBlock:^{
        [self loadLocalData];
    }];
//    rxzTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    rxzTableView.delegate = self;
    rxzTableView.dataSource = self;
//    [rxzScrollView setPullingRefreshBlock:^{
//        [self loadData];
//    }];
//    
//    [rxzScrollView setDownReloadDataBlock:^{
//        [self loadLocalData];
//    }];
//    RxzScrollView.backgroundColor = [UIColor redColor];
    /*
     RxzScrollView.showsHorizontalScrollIndicator = YES;
     RxzScrollView.showsVerticalScrollIndicator = YES;
     RxzScrollView.contentOffset = CGPointMake(0, 0);
     RxzScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
     RxzScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
     RxzScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-48);
     */
    rxzTableView.alwaysBounceHorizontal = FALSE;
    rxzTableView.showsHorizontalScrollIndicator = YES;
    rxzTableView.showsVerticalScrollIndicator = YES;
    rxzTableView.separatorColor = [UIColor greenColor];
//    rxzTableView.rowHeight = 60;
    rxzTableView.scrollEnabled = YES;
    [self.view addSubview:rxzTableView];

}

- (void)loadData
{

}

- (void)loadLocalData
{
    
}

- (void)click
{
    NSLog(@"点击了");
}

- (void)showToolView:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"个人"])
    {
        
        self.AnmiationBlock(YES);
    }
    else
    {
        self.AnmiationBlock(NO);
    }
    
}



- (NSInteger)tableView:(PullingTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(PullingTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(PullingTableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(PullingTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde] autorelease];
        UILabel *lable = [[UILabel alloc]initWithFrame:cell.contentView.bounds];
        [cell.contentView addSubview:lable];
        [lable release];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatContentBaseViewController *controller = [[ChatContentBaseViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma scrollerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    NSLog(@"contentOffset==%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-50)
    {
        rxzTableView.upLoadingView.frame =CGRectMake(rxzTableView.upLoadingView.frame.origin.x,
                                                        scrollView.contentOffset.y,
                                             rxzTableView.upLoadingView.frame.size.width,
                                                        -scrollView.contentOffset.y);
    }
    [rxzTableView.upLoadingView setNeedsDisplay];
}// any offset changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2)
{

}// any zoom scale changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{

}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [rxzTableView.upLoadingView setNeedsDisplay];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

}// called on finger up as we are moving

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}// called when scroll view grinds to a halt

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//
//}// return a view that will be scaled. if delegate returns nil, nothing happens
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2){

} // called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{

}// scale between minimum and maximum. called after any 'bounce' animations

//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;   // return a yes if you want to scroll to the top. if not defined, assumes YES
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    
}

@end
