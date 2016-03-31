//
//  LeftToolViewController.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/5.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "RootViewController.h"
#import "PublicFile.h"

@interface LeftToolViewController : RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *leftToolView;
}
@property (nonatomic,retain) UITableView *leftToolView;
@property (nonatomic,copy)  RestoreViewBlock restoreBlock;

@end
