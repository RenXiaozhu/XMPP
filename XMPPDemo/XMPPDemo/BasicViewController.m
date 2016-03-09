//
//  BasicViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/7.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "BasicViewController.h"
#import "VideoPlayerStreamViewController.h"
#import "FXBlurView.h"
@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLog(@"----");
    
    self.view.backgroundColor = [UIColor clearColor];
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(100, 100, 100, 80)];
    [btn setTitle:@"videoBtn" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(pushToVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    FXBlurView *blruView = [[FXBlurView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
//    [blruView setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2]];
//    blruView.dynamic = YES;
//    blruView.blurRadius = 5;
//    [self.view addSubview:blruView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.interfaceOrientation!= UIInterfaceOrientationPortrait) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationPortrait];
//            [UIViewController attemptRotationToDeviceOrientation];
        }
    }
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
//    self.navigationController.navigationBar.opaque=NO;
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];

}

- (void)pushToVideo
{
//    
//    NSURL *url = [NSURL URLWithString:@"http://stream.flowplayer.org/bauhaus/624x260.mp4"
//                  ];
//    VideoPlayerStreamViewController *controller = [[VideoPlayerStreamViewController alloc]initWithUrl:url deleget:self];
//    [self.navigationController showViewController:controller sender:nil];
//    [controller release];
//    
    
    XMPPManager *manage = [XMPPManager sharedManager];
    
    [manage loginWithName:@"user3" Password:@"r185933685" completion:^(NSString *str){
        CLog(@"%@",str);
    }];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    NSLog(@"willTransitionToTraitCollection");
    CLog(@"%@",[NSDate date]);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CLog(@"%@",[NSDate date]);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
