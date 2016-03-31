//
//  FunctionTestViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/17.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "FunctionTestViewController.h"
#import "VidiconViewController.h"
#import "MediaPlayerManager.h"
//#import "AgeCalculateViewController.h"
#import "TestAnimationBtnView.h"
@interface FunctionTestViewController ()
{
    NSMutableArray *arr;
    UITableView *fTableView;
}
@end

@implementation FunctionTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    self.view.backgroundColor = [UIColor whiteColor];
    arr = [[NSMutableArray  alloc]initWithObjects:@"vidicon",@"video",@"audiio",@"animationBtn",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    fTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-49) style:UITableViewStylePlain];
    fTableView.delegate = self;
    fTableView.dataSource = self;
    [self.view addSubview:fTableView];
    
    
    // Do any additional setup after loading the view.
}



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cellIde";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
    }
    DDLogInfo(@"gggg%d",(int)indexPath.section);
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0:
        {
            VidiconViewController *vidicon = [[VidiconViewController alloc]init];
            [self.navigationController pushViewController:vidicon animated:YES];
            vidicon.hidesBottomBarWhenPushed = YES;
//            [vidicon release];
            [self.tabBarController.tabBar setHidden:YES];
        }
            break;
        case 1:
        {
            
//            [NSString stringWithFormat:@"%@/%@.mov",
//             [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],
//             [dateFormatter stringFromDate:[NSDate date]]];
            
            NSFileManager *file = [NSFileManager defaultManager];
            
            NSArray *arr = [file contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] error:nil];
            
            [file removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
            
//            DDLogInfo(@"%@",arr);
            
            NSString *url = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0],@"Movie1.mov"];
            
            MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc]
                                                       initWithContentURL:[NSURL URLWithString:url]];
            controller.moviePlayer.movieSourceType = MPMovieSourceTypeFile;

//            NSData *data = [file contentsAtPath:url];
//            
//            MPMoviePlayerController *controller = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:controller animated:YES];
//            [self.view addSubview:controller.view];
            [self presentMoviePlayerViewControllerAnimated:controller];
//            MediaPlayerManager *manager = [MediaPlayerManager standardManage];
//            [manager setTargetController:self];
//            [manager playVideoWithUrl:[NSURL URLWithString:url] Deleget:self];
            
        }
            break;
        case 2:
        {
//            AgeCalculateViewController *age = [[AgeCalculateViewController alloc]init];
//            [self.navigationController pushViewController:age animated:YES];
//            [age release];
        }
            break;
        case 3:
        {
            TestAnimationBtnView *animationBtnView = [[TestAnimationBtnView alloc]init];
            [self.navigationController pushViewController:animationBtnView animated:YES];
//            [animationBtnView release];
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
