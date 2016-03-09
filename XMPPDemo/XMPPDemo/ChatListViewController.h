//
//  ChatListViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "RootViewController.h"
#import "PullingTableView.h"

typedef void(^AnmiationBlock)(BOOL leftOrRight);

@interface ChatListViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
   
}

@property (nonatomic,copy) AnmiationBlock AnmiationBlock;



@end
