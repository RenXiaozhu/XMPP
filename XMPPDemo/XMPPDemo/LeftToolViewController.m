//
//  LeftToolViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/5.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "LeftToolViewController.h"
#import "TableBarViewController.h"
#import "RootNavViewController.h"

@interface  LeftToolViewController ()
{
    NSMutableArray *leftTitleArray;
}
@end

@implementation LeftToolViewController
@synthesize leftToolView;


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    leftTitleArray = [[NSMutableArray alloc]initWithObjects:@[@"头像"],@[@"签名"],@[@"开通会员",@"QQ钱包",@"网上营业厅",@"个性装扮",@"我的收藏",@"我的相册",@"我的文件"],nil];
    leftToolView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH*LEFTSCALING,SCREEN_HEIGHT)style:UITableViewStyleGrouped];
    leftToolView.backgroundColor = [UIColor clearColor];
    leftToolView.separatorColor = [UIColor blackColor];
    leftToolView.delegate = self;
    leftToolView.dataSource = self;
    [self.view addSubview:leftToolView];
}

#pragma TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
        switch (section) {
            case 0:
            {
                number = 1;
            }
                break;
            case 1:
            {
                number = 1;
            }
                break;
            case 2:
            {
                number = 7;
            }
                break;
            default:
                break;
        }
    
    return number;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
        if (indexPath.section == 0||indexPath.section == 1)
        {
            height = 80;
        }
        else
        {
            height = 40;
        }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellide = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellide];
        if (cell==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellide] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
            iconView.tag = 1111;
            [cell.contentView addSubview:iconView];
            [iconView release];
            
            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width+5, 0, 100, 40)];
            titleLable.backgroundColor = [UIColor clearColor];
            titleLable.tag = 1112;
            titleLable.textAlignment = NSTextAlignmentCenter;
            titleLable.font = [UIFont systemFontOfSize:16];
            titleLable.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:titleLable];
            [titleLable release];
        }
        
        UILabel *titleLable = (UILabel *)[cell.contentView viewWithTag:1112];
        titleLable.text = [[leftTitleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    RestoreViewBlock block = [self.restoreBlock retain];
    
    if (block)
    {
        block([[leftTitleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    }
    Block_release(block);
    
}

@end
