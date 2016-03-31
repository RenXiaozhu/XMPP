//
//  TableBarViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/7.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "TableBarViewController.h"

static TableBarViewController *tabbarViewController;

@implementation UITabBarController (TableBarViewControllerSupport)

- (TableBarViewController *)tableBarViewController
{
    return tabbarViewController;
}
@end


@interface TableBarViewController ()

@end

@implementation TableBarViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        tabbarViewController = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
