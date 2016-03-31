//
//  FriendListViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "RootViewController.h"
#import "PullingTableView.h"

@interface FriendListViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    PullingTableView *listTableView;
    NSMutableArray *fdltArray;
    NSMutableArray *schltArray;
}

@property (nonatomic,retain) PullingTableView *listTableView;
@property (nonatomic,retain) NSMutableArray *fdltArray;
@property (nonatomic,retain) NSMutableArray *schltArray;
@end
