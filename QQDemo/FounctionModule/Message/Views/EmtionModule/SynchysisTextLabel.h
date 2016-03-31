//
//  SynchysisTextLabel.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/8.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SynchysisTextLabel : UIView
{
    NSString *showText;
}

@property (nonatomic,retain) NSString *showText;


- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame inputText:(NSString *)text;

- (void)upDateContentWithText:(NSString *)text;



@end
