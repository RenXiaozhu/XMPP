//
//  RootNavViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/13.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "RootNavViewController.h"



@interface RootNavViewController ()

@end

@implementation RootNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationBar setBackgroundColor:[UIColor redColor]];
    
}

//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}

-(NSUInteger)supportedInterfaceOrientations
{
    
    return [self.visibleViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self.visibleViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
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
