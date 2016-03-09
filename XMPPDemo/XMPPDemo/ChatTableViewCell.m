//
//  ChatTableViewCell.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/26.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell
@synthesize textLabel;
@synthesize postImg;
@synthesize photoBtn;
@synthesize filePostOrRecvProgress;
@synthesize isSenderOrReceiver;
@synthesize recordData;
@synthesize talkView;
@synthesize cellShareModelView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (id)init
{
    self = [super init];
    if (self) {
//        NSArray *arr1 = arr(2,5);
//        
//        NSLog(@"%@",arr1);
        
    }
    
    return self;
}



@end
