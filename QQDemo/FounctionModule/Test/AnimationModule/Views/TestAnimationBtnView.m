
//
//  TestAnimationBtnView.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/30.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "TestAnimationBtnView.h"
#import "BasicAnimationBtn.h"
//#import "XMPPDemo-swift.h"
@implementation TestAnimationBtnView


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *img = [UIImage imageNamed:@"00.jpg"];
    
    BasicAnimationBtn *btn = [[BasicAnimationBtn alloc]initWithFrame:CGRectMake(100, 200, img.size.width, img.size.height) AnimationType:KCBtnAnmationDefaultType];
//    [btn setBackgroundImage: forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setBtnDuration:2.1];
    [btn addTarget:self action:@selector(doNothing:) forControlEvents:UIControlEventTouchUpInside animationWhenTouch:YES];
    [self.view addSubview:btn];
    
    BasicAnimationBtn *btn1 = [[BasicAnimationBtn alloc]initWithFrame:CGRectMake(100, 400, 100, 100) AnimationType:KCBtnAnimationRotateType];
//    btn1.backgroundColor = [UIColor redColor];
    //    [btn setBackgroundImage: forState:UIControlStateNormal];
//    [btn setImage:img forState:UIControlStateNormal];
    [btn1 setBtnDuration:2.1];
    [btn1 addTarget:self action:@selector(doNothing:) forControlEvents:UIControlEventTouchUpInside animationWhenTouch:YES];
    [self.view addSubview:btn1];
    [btn1 setNeedsDisplay];
    
}


- (void)doNothing:(UIButton *)btn
{
//    SwiftTestViewController *swift = [[SwiftTestViewController alloc]init];
//    swift.tbnt.frame = CGRectMake(0, 0, 0, 0);
//    [self.navigationController pushViewController:swift animated:YES];
    
}

- (void)dealloc
{
    
//    [super dealloc];
}

@end
