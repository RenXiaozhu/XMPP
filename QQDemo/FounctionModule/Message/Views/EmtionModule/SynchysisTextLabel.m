//
//  SynchysisTextLabel.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/8.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "SynchysisTextLabel.h"

@implementation SynchysisTextLabel
@synthesize showText;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    
    if (self)
    {
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame inputText:(NSString *)text
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showText = text;
        [self analysisText:text];
    }
    return self;
}


- (void)analysisText:(NSString *)text
{
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
