//
//  RoghtToolViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/5.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "RoghtToolViewController.h"
#import "PublicFile.h"

@interface  RoghtToolViewController ()
{
    NSMutableArray *leftTitleArray;
    NSMutableArray *rightTitleArray;
}
@end

@implementation RoghtToolViewController
@synthesize rightToolView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    rightTitleArray = [[NSMutableArray alloc]initWithObjects:@"扫一扫",@"建讨论组",@"面对面",@"群组电话",@"我的电脑",@"加好友", nil];
    rightToolView = [[UITableView alloc]initWithFrame:
                     CGRectMake( SCREEN_WIDTH*RIGHTSCALING,
                                 0,
                                 SCREEN_WIDTH*(1-RIGHTSCALING),
                                 SCREEN_HEIGHT
                                )
                                                style:UITableViewStyleGrouped];
    rightToolView.backgroundColor = [UIColor clearColor];
    rightToolView.separatorColor = [UIColor clearColor];
    rightToolView.delegate   = self;
    rightToolView.dataSource = self;
    [self.view addSubview:rightToolView];
    
}


#pragma TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
            number = 6;
    
    return number;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
            height = 120;
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellide = @"rightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellide];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellide];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*(1-RIGHTSCALING)/2-20, 5, 40, 40)];
            iconView.tag = 1113;
            [cell.contentView addSubview:iconView];
//            [iconView release];
            
            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, iconView.frame.origin.y+iconView.frame.size.height+5, SCREEN_WIDTH*(1-RIGHTSCALING), 20)];
            titleLable.backgroundColor = [UIColor clearColor];
            titleLable.tag = 1114;
            titleLable.font = [UIFont systemFontOfSize:16];
            titleLable.textAlignment = NSTextAlignmentCenter;
            titleLable.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:titleLable];
//            [titleLable release];
        }
        
        UILabel *titleLable = (UILabel *)[cell.contentView viewWithTag:1114];
        titleLable.text =[rightTitleArray objectAtIndex:indexPath.row];
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestoreViewBlock block = self.restoreBlock;
    if (block)
    {
        block([rightTitleArray objectAtIndex:indexPath.row]);
    }
//    Block_release(block);
}


- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
@end
