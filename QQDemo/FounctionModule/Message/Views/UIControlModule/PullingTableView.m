//
//  MytableView.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/13.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "PullingTableView.h"

@implementation PullingTableView
{
    CGFloat _keyboardHeight;
}

@synthesize DownActivity;
@synthesize downTipView;
@synthesize DowntipLable;
@synthesize upLoadingView;
@synthesize pullingRefreshBlock;
@synthesize downReloadDataBlock;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
//{
//    self = [super initWithFrame:frame style:style];
//    
//    if (self)
//    {
////        self.pullingRefreshBlock = pullingRefreshBlock;
////        self.downReloadDataBlock = downReloadDataBlock;
//        
//        downTipView = [[UIView alloc]initWithFrame:
//                       CGRectMake(0,
//                                  self.contentSize.height,
//                                  frame.size.width,
//                                  frame.size.height)];
//        downTipView.backgroundColor = self.backgroundColor;
//        [self addSubview:downTipView];
//        
//        DowntipLable = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x, 60, 100, 30)];
//        DowntipLable.backgroundColor = [UIColor clearColor];
//        DowntipLable.text = @"";
//        DowntipLable.font = [UIFont systemFontOfSize:12];
//        DowntipLable.textAlignment = UITextAlignmentCenter;
//        DowntipLable.textColor = [UIColor whiteColor];
//        [downTipView addSubview:DowntipLable];
//        
//        DownActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        DownActivity.frame = CGRectMake(self.center.x-50, DowntipLable.frame.origin.y-60, 30, 30);
//        [downTipView addSubview:DownActivity];
//        
//        
//        self.upLoadingView = [[WaterDropLoadingView alloc]initDefaultViewWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 50)];
//        self.upLoadingView.backgroundColor = [UIColor whiteColor];
//        __block PullingTableView *tableView = self;
//        
//        [self.upLoadingView setChangTableViewStateBlock:^(LoadingState state){
//            
//            switch (state) {
//                case NSLoadingViewInLoadingDataState:
//                {
//                    tableView.contentOffset = CGPointMake(0, -50);
//                }
//                    break;
//                case NSLoadingViewFinishedLoadDataState:
//                {
//                    tableView.contentOffset = CGPointMake(0, 0);
//                }
//                    break;
//                case NSLoadingViewErrorLoadDataState:
//                {
//                    tableView.contentOffset = CGPointMake(0, 0);
//                }
//                    break;
//                default:
//                    break;
//            }
//            
//        }];
//        
//        [self addSubview:self.upLoadingView];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    }
//    return self;
//}

- (instancetype)initPullingTableViewWithFrame:(CGRect)rect style:(UITableViewStyle)style pullingRefreshBlock:(void (^)(void))pullRefreshBlock downReloadDataBlock:(void (^)(void))downReloadBlock
{
    
    self = [super initWithFrame:rect style:style];
    
    if (self)
    {
        
        self.pullingRefreshBlock = pullRefreshBlock;
        self.downReloadDataBlock = downReloadBlock;
        
//        downTipView = [[UIView alloc]initWithFrame:
//                                                   CGRectMake(0,
//                                                   self.contentSize.height,
//                                                   rect.size.width,
//                                                   rect.size.height)];
//        downTipView.backgroundColor = self.backgroundColor;
//        [self addSubview:downTipView];
    
//        DowntipLable = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x, 60, 100, 30)];
//        DowntipLable.backgroundColor = [UIColor clearColor];
//        DowntipLable.text = @"";
//        DowntipLable.font = [UIFont systemFontOfSize:12];
//        DowntipLable.textAlignment = UITextAlignmentCenter;
//        DowntipLable.textColor = [UIColor whiteColor];
//        [downTipView addSubview:DowntipLable];
//        
//        DownActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        DownActivity.frame = CGRectMake(self.center.x-50, DowntipLable.frame.origin.y-60, 30, 30);
//        [downTipView addSubview:DownActivity];
        
        
        upLoadingView = [[WaterDropLoadingView alloc]initDefaultViewWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 50)];
        upLoadingView.backgroundColor = [UIColor redColor];
        __block PullingTableView *tableView = self;
        
        [self.upLoadingView setChangTableViewStateBlock:^(LoadingState state){
            
            switch (state) {
                case NSLoadingViewInLoadingDataState:
                {
                    tableView.contentOffset = CGPointMake(0, -50);
                    tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
                    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0);
                }
                    break;
                case NSLoadingViewFinishedLoadDataState:
                {
                    tableView.contentOffset = CGPointMake(0, 0);
                    tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
                    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0);
                }
                    break;
                case NSLoadingViewErrorLoadDataState:
                {
                    tableView.contentOffset = CGPointMake(0, 0);
                    tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
                    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0);
                }
                    break;
                default:
                    break;
            }
            
        }];
        
        [self addSubview:self.upLoadingView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    
    return self;
}


- (void)didMoveToSuperview
{
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{

    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    
    _keyboardHeight=keyboardRect.size.height;
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{

    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    
    _keyboardHeight=keyboardRect.size.height;
    
}

- (void)pullingData
{

    if (self.contentOffset.y >=50)
    {
        [self.upLoadingView upDateLoadingStateWithState:NSLoadingViewInLoadingDataState];
        self.downReloadDataBlock();
    }
    else if (self.contentOffset.y <=-50)
    {
        self.scrollEnabled=NO;
//        [DownActivity startAnimating];
//        DowntipLable.text=@"加载中...";
        self.pullingRefreshBlock();
    }
}


- (BOOL)judgePullingDirector
{

    BOOL ret;
    
    if (self.contentOffset.y >=50)
    {
        ret = YES;//往下拉
    }
    else if (self.contentOffset.y <=-50)
    {
        ret = NO;//往上拽
    }
    
    return ret;
}


- (void)restoreTableView
{

    self.contentOffset=CGPointMake(0, 0);
    self.scrollEnabled=YES;

    if ([self judgePullingDirector])
    {
        [self.upLoadingView upDateLoadingStateWithState:NSLoadingViewFinishedLoadDataState];
    }
    else
    {
        [DownActivity stopAnimating];
    }
    
}



- (void)updateLoadingStateWithState:(LoadingState)state
{
    self.upLoadingView.state = state;
    [self.upLoadingView setNeedsDisplay];
}

#pragma scrollerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"contentOffset==%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-50)
    {
        upLoadingView.frame =CGRectMake(upLoadingView.frame.origin.x,
                                                     scrollView.contentOffset.y,
                                                     upLoadingView.frame.size.width,
                                                     -scrollView.contentOffset.y);
    }
    [upLoadingView setNeedsDisplay];
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
    [upLoadingView setNeedsDisplay];
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
