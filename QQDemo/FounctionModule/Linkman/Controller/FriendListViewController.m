//
//  FriendListViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "FriendListViewController.h"
#import "XMPPManager.h"
#import "FriendListBaseModel.h"

@interface FriendListViewController ()
{
    
}
@end

@implementation FriendListViewController

@synthesize listTableView;
@synthesize fdltArray;
@synthesize schltArray;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initUI];
    
}

- (void)initUI
{
    __block FriendListViewController *friendList = self;
    
    listTableView = [[PullingTableView alloc]
                    initPullingTableViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)
                    style:UITableViewStylePlain
                    pullingRefreshBlock:^{
                      
                    XMPPManager *manage = [XMPPManager sharedManager];
                    [manage getUserList:^(NSArray *arr){
                        
                        [friendList.listTableView restoreTableView];
                      if (friendList.fdltArray==nil)
                        {
                          fdltArray = [[NSMutableArray alloc]initWithArray:arr];
                        }
                        else
                        {
                          [fdltArray removeAllObjects];
                          [fdltArray addObjectsFromArray:arr];
                        }
                          [friendList.listTableView reloadData];
                        }];
        
                    }
                downReloadDataBlock:nil];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    
    [self.view  addSubview:listTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
        
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(10, 10, 30, 30);
    [btn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view ;
}

- (void)addFriend
{
    XMPPManager *manage = [XMPPManager sharedManager];
    [manage addUser:@"user3"];
}



#pragma scrollerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"contentOffset==%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-50)
    {
        listTableView.upLoadingView.frame =CGRectMake(listTableView.upLoadingView.frame.origin.x,
                                                     scrollView.contentOffset.y,
                                                     listTableView.upLoadingView.frame.size.width,
                                                     -scrollView.contentOffset.y);
    }
    else
    {
        listTableView.pullingRefreshBlock();
    }
    [listTableView.upLoadingView setNeedsDisplay];
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
    [listTableView.upLoadingView setNeedsDisplay];
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
