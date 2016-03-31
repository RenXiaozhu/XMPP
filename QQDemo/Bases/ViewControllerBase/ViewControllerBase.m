//
// Created by fengshuai on 15/10/8.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import "ViewControllerBase.h"
#import "SlideNavigationController.h"
//#import "MobClick.h"

@interface ViewControllerBase()

@end

@implementation ViewControllerBase
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor= [UIColor whiteColor];

    [self setLeftButton];
    
    [self setNavBg];
    
    [self setBGColor:@"#fefefe"];
    
}

//设置默认左侧按钮
- (void)setLeftButton
{
    //左侧按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage;
    UIImage *leftHighliteImage;
    if (![self canBePopedBack]&&!self.presentingViewController)
    {
        //菜单
        leftImage = GET_IMAGE_FROM_BUNDLE_PATH(@"btn-navi-menu" ,@"biz");
        leftHighliteImage = GET_IMAGE_FROM_BUNDLE_PATH(@"btn-navi-menu" ,@"biz");
    }
    else if ([self canBePopedBack])
    {
        //返回
        leftImage = GET_IMAGE_FROM_BUNDLE_PATH(@"btn-back" ,@"biz");
        leftHighliteImage = GET_IMAGE_FROM_BUNDLE_PATH(@"btn-back" ,@"biz");
    }
    else//关闭
    {
        leftImage = GET_IMAGE_FROM_BUNDLE_PATH(@"btn-close" ,@"biz");
        leftHighliteImage = GET_IMAGE_FROM_BUNDLE_PATH(@"btn-close" ,@"biz");
    }


    [leftButton setImage:leftImage forState:UIControlStateNormal];
    [leftButton setImage:leftHighliteImage forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];

    leftButton.hidden=self.leftBarButtonHidden;
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:leftButton];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SlideNavigationController sharedInstance].enableSwipeGesture=![self canBePopedBack]&&!self.presentingViewController;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    
}

- (void)leftButtonAction:(id)sender
{
    if ([self canBePopedBack])
    {
        //返回
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (self.presentingViewController)
    {
        //从模态对话框退出
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        //通知框架弹出菜单
//        [[NSNotificationCenter defaultCenter] postNotificationName:POP_MENU_NOTIFICATION object:self];
    }
}

//是否能回退
- (BOOL)canBePopedBack
{
    return [self.navigationController.viewControllers count] > 1 && [self.navigationController.topViewController isEqual:self];
}


- (void)showShareListWithBlock:(void (^)(NSInteger))block
{
    
    
//    if (_shareView == nil)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"viewControllerShareViewStart" object:nil];
//        
//        _shareView = [[YUDShareBtnView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) block:block];
//        [self.view addSubview:_shareView];
//        
//        @weakify(self);
//        [self.view returnScreenshotDataAndThumbDataViewWithScale:[UIScreen mainScreen].scale
//                                                           Block:^(NSData *data,NSData *thumbdata) {
//            @strongify(self);
//            
//            self.cutScreenData = data;
//            self.thumbnail = thumbdata;
//            
//        } completion:^{
//            
//            [self.shareView showShareList];
//            
//        }];
//        
//    }
//    
//    if (_shareView.isOpen)
//    {
//        [_shareView HideShareList];
//    }
//    else
//    {
//        
//        if (self.cutScreenData)
//        {
//            [_shareView showShareList];
//            
//        }
//    }
    
}

- (void)showShareList
{
//    [_shareView showShareList];
}

- (void)hideShareList
{
//    [_shareView HideShareList];
    
//    [self releaseImgData];
}


- (void)showLoadingView
{
    
    if (_loadingView == nil)
    {
        _loadingView = [[YUDLoadingViewBase alloc]initWithFrame:self.view.bounds];
        _loadingView.alpha = 0.0;
        [self.view addSubview:_loadingView];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        _loadingView.alpha = 1.0;
        [_loadingView startLoading];
    }];
    
}

- (void)hideLoadingView
{
    [UIView animateWithDuration:0.1 animations:^{
        _loadingView.alpha = 0.0;
        [_loadingView stopLoading];
    }];
    [_loadingView removeFromSuperview];
}


- (void)setNavBg
{
    
    self.navigationController.navigationBar.shadowImage  = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#69bce4"];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"#69bce4"];
    self.navigationController.navigationBar.tintColor     = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}];
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:0 barMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}

- (void)setBGColor:(NSString *)colorString
{
    [self.view setBackgroundColor:[UIColor colorWithHexString:colorString]];
}

- (void)setbackgroundImageWithIndex:(ControllerBackImgType)type
{
    if (type==ControllerBackImgTypeNone)
        return;
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:img];
    
    switch (type) {

        case ControllerBackImgTypeDribble:
        {
            [img setImage:GET_IMAGE_FROM_BUNDLE_PATH(@"img-bg-dribble", @"biz")];
        }
            break;
        case ControllerBackImgTypePass:
        {
            [img setImage:GET_IMAGE_FROM_BUNDLE_PATH(@"img-bg-pass", @"biz")];
        }
            break;
        case ControllerBackImgTypeShoot:
        {
            [img setImage:GET_IMAGE_FROM_BUNDLE_PATH(@"img-bg-shooting", @"biz")];
        }
            break;
        case ControllerBackImgTypeLogin:
        {
            [img setImage:GET_IMAGE_FROM_BUNDLE_PATH(@"img-login-bg", @"biz")];
        }
            break;
        case ControllerBackImgTypeProfile:
        {
            [img setImage:GET_IMAGE_FROM_BUNDLE_PATH(@"img-profile-bg", @"biz")];
        }
            break;
        default:
            break;
    }
}

- (void)releaseImgData
{
    self.cutScreenData = nil;
    self.thumbnail     = nil;
}

- (void)dealloc
{
    [self releaseImgData];
    NSLog(@"Finalize :%@",self.debugDescription);
}


@end