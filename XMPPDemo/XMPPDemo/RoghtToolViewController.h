//
//  RoghtToolViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/5.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "RootViewController.h"
#import "PublicFile.h"

@interface RoghtToolViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *rightToolView;
}

@property (nonatomic,retain) UITableView *rightToolView;
@property (nonatomic,copy)   RestoreViewBlock restoreBlock;
@end
