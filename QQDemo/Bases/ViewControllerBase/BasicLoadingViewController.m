//
//  BasicLoadingViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/28.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "BasicLoadingViewController.h"
#import "WADynamicViewController.h"
#import "FriendListViewController.h"
#import "ChatListViewController.h"
#import "UIColor+_16ToRGB.h"
#import "FunctionTestViewController.h"


@interface BasicLoadingViewController ()
{
   
    UITouch *onlyTouch;
    BOOL isLeftOrRightTool;
    BOOL isShowToolView;
    CGFloat leftToolScalef;
    CGFloat rightToolScalef;
    CGFloat mainScalef;
    
}

@end

@implementation BasicLoadingViewController
@synthesize leftToolView;
@synthesize rightToolView;
@synthesize tableBarViewController;
@synthesize startPoint;
@synthesize endPoint;



- (void)animateViewWithleftOrRight:(BOOL)leftOrRight
{
    isLeftOrRightTool = leftOrRight;
    if (isShowToolView==NO) {
        isShowToolView = YES;
        self.tableBarViewController.view.transform = CGAffineTransformIdentity;
        self.leftToolView.view.transform = CGAffineTransformIdentity;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        isLeftOrRightTool = leftOrRight;
        if (leftOrRight)
        {
            leftToolScalef = 1.0;
            mainScalef = LEFTSCALING;
            self.rightToolView.view.alpha = 0.0;
            self.tableBarViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,mainScalef,mainScalef);
            self.tableBarViewController.view.center = CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2);
            self.leftToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            self.leftToolView.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            self.leftToolView.view.alpha = 1.0;
            
        }
        else
        {
            mainScalef = MAINVIEWSCALING;
            rightToolScalef = 1.0;
            self.leftToolView.view.alpha = 0.0;
            self.tableBarViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,mainScalef,mainScalef);
            self.tableBarViewController.view.center = CGPointMake(SCREEN_WIDTH/2-SCREEN_WIDTH*(1-MAINVIEWSCALING), SCREEN_HEIGHT/2);
            
            self.rightToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            self.rightToolView.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            self.rightToolView.view.alpha = 1.0;
        }
        [UIView commitAnimations];
    }
    else
    {
        [self animationadjustViewWithTouchItem:YES];
    }
    
    

}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    onlyTouch = [touches anyObject];
//    
//    startPoint = [onlyTouch locationInView:tableBarViewController.view];
//    DDLogInfo(@"startPoint  x==%f y==%f",startPoint.x,startPoint.y);
//    
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    static CGPoint point1;
//    static CGPoint point2;
//    onlyTouch = [touches anyObject];
//    endPoint = [onlyTouch locationInView:tableBarViewController.view];
//    point1 = endPoint;
//    DDLogInfo(@"endPoint  x==%f y==%f",endPoint.x,endPoint.y);
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        double delayInSeconds =0.01;
//        dispatch_time_t delayNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds*NSEC_PER_SEC);
//        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_after(delayNanoSeconds, concurrentQueue, ^{
//            point2 = endPoint;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (point1.x-point2.x>0)
//                {
//                    [self AnmiationViewWith:(point1.x-point2.x) direction:YES touchItem:NO showOrHidden:NO];
//                }
//                else
//                {
//                    [self AnmiationViewWith:(point2.x-point1.x) direction:NO touchItem:NO showOrHidden:YES];
//                }
//                
//            });
//        });
//    });
//    
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    if (endPoint.x == -1111 )
//    {
//        [self AnmiationViewWith:0 direction:YES touchItem:NO showOrHidden:NO];
//    }
//    else
//    {
//        if (isLeftOrRightTool)
//        {
//            if (endPoint.x < (self.view.bounds.size.width*LEFTSCALING)/2)
//            {
//                [self AnmiationViewWith:endPoint.x direction:YES touchItem:NO showOrHidden:YES];
//            }
//            else
//            {
//                [self AnmiationViewWith:(SCREEN_WIDTH-endPoint.x) direction:NO touchItem:NO showOrHidden:NO];
//            }
//        }
//        
//        
//    }
//    
//}



- (void)loadView
{
    [super loadView];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"IMG_0143"];
    [self.view addSubview:bgView];

    
    leftToolScalef = LEFTSCALING;
    rightToolScalef = RIGHTSCALING;
    
    [self initLeftToolView];
    [self initRightToolView];
    
    [self initTabbarViewController];
}


- (void)initLeftToolView
{
    leftToolView = [[LeftToolViewController alloc]init];
    
    [leftToolView setRestoreBlock:^(NSString *name){
        
        [self animationadjustViewWithTouchItem:YES];
        UIViewController *controller = [[UIViewController alloc]init];
        controller.view.backgroundColor = [UIColor whiteColor];
        RootNavViewController *nav = (RootNavViewController *)tableBarViewController.selectedViewController;
        [nav pushViewController:controller animated:YES];

        
    }];
    
    leftToolView.view.frame = CGRectMake(-SCREEN_WIDTH,
                                                     0,
                                          SCREEN_WIDTH,
                                         SCREEN_HEIGHT);
    leftToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, LEFTSCALING, LEFTSCALING);
    leftToolView.view.center = CGPointMake(0,SCREEN_HEIGHT/2);
    [self.view addSubview:leftToolView.view];
}


- (void)initRightToolView
{
    rightToolView = [[RoghtToolViewController alloc]init];
    
    [rightToolView setRestoreBlock:^(NSString *name){
        
        [self animationadjustViewWithTouchItem:YES];
        
        UIViewController *controller = [[UIViewController alloc]init];
        controller.view.backgroundColor = [UIColor whiteColor];
        RootNavViewController *nav = (RootNavViewController *)tableBarViewController.selectedViewController;
        [nav pushViewController:controller animated:YES];

        
    }];
    rightToolView.view.frame = CGRectMake(SCREEN_WIDTH,
                                                     0,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT);
    rightToolView.view.center = CGPointMake(SCREEN_WIDTH/2+SCREEN_WIDTH*(1-RIGHTSCALING), SCREEN_HEIGHT/2);
    rightToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, RIGHTSCALING, RIGHTSCALING);
    [self.view addSubview:rightToolView.view];
}

- (void)initTabbarViewController
{
    tableBarViewController = [[TableBarViewController alloc]init];
    
    ChatListViewController *chatListViewController = [[ChatListViewController alloc]init];
    
    __block BasicLoadingViewController *basicView = self;
    
    [chatListViewController setAnmiationBlock:^(BOOL isLeftOrRight)
     {
         [basicView animateViewWithleftOrRight:isLeftOrRight];
     }];
    
    RootNavViewController *chatNav = [[RootNavViewController alloc]initWithRootViewController:chatListViewController];

    
    FriendListViewController *friendListViewController = [[FriendListViewController alloc]init];
    
    RootNavViewController *friendNav = [[RootNavViewController alloc]initWithRootViewController:friendListViewController];

    
    WADynamicViewController *waDynamicViewController = [[WADynamicViewController alloc]init];
    RootNavViewController *DynamicNav = [[RootNavViewController alloc]initWithRootViewController:waDynamicViewController];
    
    FunctionTestViewController *functionTest = [[FunctionTestViewController alloc]init];
    RootNavViewController *FunctionNav = [[RootNavViewController alloc]initWithRootViewController:functionTest];
    
    UITabBarItem *chatItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage new] tag:1];
    chatListViewController.tabBarItem = chatItem;
    [chatItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    
    UITabBarItem *FriendItem = [[UITabBarItem alloc]initWithTitle:@"联系人" image:[UIImage new] tag:2];
    [FriendItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    friendListViewController.tabBarItem = FriendItem;

    
    UITabBarItem *DyItem = [[UITabBarItem alloc]initWithTitle:@"动态" image:[UIImage new] tag:3];
    [DyItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    waDynamicViewController.tabBarItem =DyItem;

    
    UITabBarItem *FtItem = [[UITabBarItem alloc]initWithTitle:@"功能测试" image:[UIImage new] tag:4];
    [FtItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    functionTest.tabBarItem =FtItem;

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>5.0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
            
            /*
             
                         [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextColor:[UIColor colorWithHexString:@"#828283"]} forState:UIControlStateNormal];
                         [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)],UITextAttributeTextColor:[UIColor colorWithHexString:@"#bb1818"]} forState:UIControlStateSelected];
                         [chatListViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:[selectArray objectAtIndex:0]] withFinishedUnselectedImage:[UIImage imageNamed:[img objectAtIndex:0]]];
                         //            _homePageViewController.tabBarItem.title=@"首页";
                         //UIEdgeInsets inset=_homePageViewController.tabBarItem.imageInsets;
             
                         _homePageViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5 , 0,-5, 0);
             
                         [_managerProductionViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:[selectArray objectAtIndex:1]] withFinishedUnselectedImage:[UIImage imageNamed:[img objectAtIndex:1]]];
             
                         _managerProductionViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0,-5, 0);
             
                         _myManagerViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0,-5, 0);
             
                         [_myManagerViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:[selectArray objectAtIndex:2]] withFinishedUnselectedImage:[UIImage imageNamed:[img objectAtIndex:2]]];
                         [_moreViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:[selectArray objectAtIndex:3]] withFinishedUnselectedImage:[UIImage imageNamed:[img objectAtIndex:3]]];
             
                         //_moreViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(6, inset.left,-5, inset.right);
                         [_moreViewController.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
              DDLogInfo(@"-----------------%f------------",inset.left);
             */
            
        }else{
            
            [[UITabBarItem appearanceWhenContainedIn:[UITabBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#828283"],NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
            [[UITabBarItem appearanceWhenContainedIn:[UITabBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bb1818"],NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
            /*
             UIImage *nonalImg=[[UIImage imageNamed:[img objectAtIndex:0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UIImage *selectImg=[[UIImage imageNamed:[selectArray objectAtIndex:0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UITabBarItem *item=[[UITabBarItem alloc]initWithTitle:@"" image:nonalImg selectedImage:selectImg];
             _homePageViewController.tabBarItem=item;
             
             [item release];
             //UIEdgeInsets inset=_homePageViewController.tabBarItem.imageInsets;
             
             
             UIImage *nonalImg1=[[UIImage imageNamed:[img objectAtIndex:1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UIImage *selectImg1=[[UIImage imageNamed:[selectArray objectAtIndex:1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UITabBarItem *item1=[[UITabBarItem alloc]initWithTitle:@"" image:nonalImg1 selectedImage:selectImg1];
             _moreViewController.tabBarItem=item1;
             _managerProductionViewController.tabBarItem=item1;
             [item1 release];
             
             
             UIImage *nonalImg2=[[UIImage imageNamed:[img objectAtIndex:2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UIImage *selectImg2=[[UIImage imageNamed:[selectArray objectAtIndex:2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UITabBarItem *item2=[[UITabBarItem alloc]initWithTitle:@"" image:nonalImg2 selectedImage:selectImg2];
             //            _moreViewController.tabBarItem=item2;
             _myManagerViewController.tabBarItem=item2;
             [item2 release];
             
             
             UIImage *nonalImg3=[[UIImage imageNamed:[img objectAtIndex:3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UIImage *selectImg3=[[UIImage imageNamed:[selectArray objectAtIndex:3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             UITabBarItem *item3=[[UITabBarItem alloc]initWithTitle:@"" image:nonalImg3 selectedImage:selectImg3];
             _moreViewController.tabBarItem=item3;
             [item3 release];
             //_moreViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(6, inset.left,-5, inset.right);
             
             if ([UIScreen mainScreen].scale==1||[UIScreen mainScreen].scale==2) {
             _moreViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
             _myManagerViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0,-5, 0);
             _managerProductionViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0,-5, 0);
             _homePageViewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5 , 0,-5, 0);
             }else{
             _homePageViewController.tabBarItem.title=@"首页";
             _moreViewController.tabBarItem.title=@"更多";
             _managerProductionViewController.tabBarItem.title=@"理财产品";
             _myManagerViewController.tabBarItem.title=@"我的理财客";
             
             }
             
             DDLogInfo(@"-----------------%f------------",inset.left);

             */
            
        }
    }
    
    
    
    NSArray *viewControllers  = [NSArray arrayWithObjects:chatNav,friendNav,DynamicNav,FunctionNav, nil];
    
    tableBarViewController.viewControllers = viewControllers;
    
    [self.view addSubview:tableBarViewController.view];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(showToolViewAnimation:)];
    [tableBarViewController.view addGestureRecognizer:pan];

}


- (void)showToolViewAnimation:(UIPanGestureRecognizer *)rec
{
    if (!isShowToolView)
    return;
    CGPoint point = [rec translationInView:self.view];
//    DDLogInfo(@"point.x==%f  point.y==%f",point.x,point.y);
//    scalef = (point.x==0?0:(point.x/SCREEN_WIDTH))+scalef;
    
    
    if (rec.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [rec locationInView:self.view];
    }
    
    if (rec.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point1 = [rec locationInView:self.view];
        
        if (isLeftOrRightTool)
        {
                if (startPoint.x-point1.x<0)
                return;
                mainScalef = ((startPoint.x-point1.x)/(SCREEN_WIDTH*LEFTSCALING))*0.4+LEFTSCALING;
                if (mainScalef>1.0||mainScalef<0.7)
                return;
                leftToolScalef = 1.0-((startPoint.x-point1.x)/(SCREEN_WIDTH*LEFTSCALING))*0.4;
            
        }
        else
        {
            if (startPoint.x-point1.x>0)
                return;
            mainScalef = MAINVIEWSCALING-(startPoint.x-point1.x)/SCREEN_WIDTH;
            DDLogInfo(@"%f",((startPoint.x-point1.x)/(SCREEN_WIDTH*LEFTSCALING))*0.4);
            if (mainScalef>1.0||mainScalef<0.75)
                return;
            rightToolScalef = 1+((startPoint.x-point1.x)/(SCREEN_WIDTH*LEFTSCALING))*0.5;
//            DDLogInfo(@"%f",rightToolScalef);
        }
        
        if (isLeftOrRightTool){
            rec.view.center = CGPointMake(rec.view.center.x + point.x,rec.view.center.y);
            rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,mainScalef,mainScalef);
            [rec setTranslation:CGPointMake(0, 0) inView:self.view];
            
            leftToolView.view.center = CGPointMake(leftToolView.view.center.x + point.x*SCALINGSPEED,leftToolView.view.center.y);
            leftToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,leftToolScalef,leftToolScalef);
        }
        else
        {
            rec.view.center = CGPointMake(rec.view.center.x + point.x,rec.view.center.y);
            rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,mainScalef,mainScalef);
            
            rightToolView.view.center = CGPointMake(rightToolView.view.center.x + point.x*SCALINGSPEED,rightToolView.view.center.y);
            rightToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,rightToolScalef,rightToolScalef);
            
            [rec setTranslation:CGPointMake(0, 0) inView:self.view];
            
        }
    }
    
    
    
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded)
    {
        [self animationadjustViewWithTouchItem:NO];
    }

    
    
    
}


- (void)animationadjustViewWithTouchItem:(BOOL)isTouch
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0f];
    self.tableBarViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,mainScalef,mainScalef);
    self.leftToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftToolScalef, leftToolScalef);
    self.rightToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, rightToolScalef, rightToolScalef);
    [UIView commitAnimations];
    
    CGPoint mainViewCenterPoint;
    CGPoint leftViewCenterPoint;
    CGPoint rightViewCenterPoint;
    if (!isTouch)
    {
        if (isLeftOrRightTool)
        {
            
            if (mainScalef>0.85)
            {
                mainScalef = 1.0;
                leftToolScalef = 0.7;
                mainViewCenterPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                leftViewCenterPoint = CGPointMake(0, SCREEN_HEIGHT/2);
                isShowToolView = NO;
            }
            else
            {
                mainScalef = 0.7;
                leftToolScalef = 1.0;
                mainViewCenterPoint =CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2);
                leftViewCenterPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                isShowToolView = YES;
            }
        }
        else
        {
            if (mainScalef>0.90f)
            {
                mainScalef = 1.0f;
                rightToolScalef = 0.85f;
                mainViewCenterPoint  = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                rightViewCenterPoint = CGPointMake(SCREEN_WIDTH/2+SCREEN_WIDTH*(1-RIGHTSCALING), SCREEN_HEIGHT/2);
                isShowToolView = NO;
            }
            else
            {
                mainScalef = MAINVIEWSCALING;
                rightToolScalef = 1.0f;
                mainViewCenterPoint =  CGPointMake( SCREEN_WIDTH/2-SCREEN_WIDTH*(1-MAINVIEWSCALING), SCREEN_HEIGHT/2);
                rightViewCenterPoint = CGPointMake( SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                isShowToolView = YES;
            }
        }
    }
    else
    {
        if (isLeftOrRightTool)
        {
                mainScalef = 1.0;
                leftToolScalef = 0.7;
                mainViewCenterPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                leftViewCenterPoint = CGPointMake( 0, SCREEN_HEIGHT/2);
                isShowToolView = NO;
        }
        else
        {
                mainScalef = 1.0f;
                rightToolScalef = 0.7f;
                mainViewCenterPoint  = CGPointMake( SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                rightViewCenterPoint = CGPointMake( SCREEN_WIDTH/2+SCREEN_WIDTH*(1-RIGHTSCALING), SCREEN_HEIGHT/2);
                isShowToolView = NO;
        }
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.tableBarViewController.view.center = mainViewCenterPoint;
    self.tableBarViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,mainScalef,mainScalef);
    if (isLeftOrRightTool)
    {
        self.leftToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftToolScalef, leftToolScalef);
        self.leftToolView.view.center = leftViewCenterPoint;
    }
    else
    {
        self.rightToolView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, rightToolScalef, rightToolScalef);
        self.rightToolView.view.center = rightViewCenterPoint;
    }
    
    [UIView commitAnimations];
   
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    startPoint = CGPointMake(-1111, -11111);
    endPoint   = CGPointMake(-1111, -11111);
    isShowToolView = NO;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



- (void)dealloc
{
    leftToolView = nil;
    rightToolView = nil;
    tableBarViewController = nil;

}

@end
