//
//  ChatTableViewCell.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/26.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellShareModelView.h"
#import "MediaPlayerManager.h"

NSArray *(arr)(CGFloat t,CGFloat x);

@interface ChatTableViewCell : UITableViewCell
{
    UIButton *photoBtn;      //头像
    BOOL isSenderOrReceiver; //是发送者还是接受者
    UILabel *talkView;       //对话框
    UIImageView *postImg;    //发送图片
    UIProgressView *filePostOrRecvProgress;//文件发送或接收的进度
    CellShareModelView *cellShareModelView;//分享模块
    NSMutableData *recordData;//录音文件
}


@property (nonatomic,retain) UIButton *photoBtn;      //头像
@property (nonatomic,assign) BOOL isSenderOrReceiver; //是发送者还是接受者
@property (nonatomic,retain) UILabel *talkView;       //对话框
@property (nonatomic,retain) UIImageView *postImg;    //发送图片
@property (nonatomic,retain) UIProgressView *filePostOrRecvProgress;//文件发送或接收的进度
@property (nonatomic,retain) CellShareModelView *cellShareModelView;//分享模块
@property (nonatomic,retain) NSMutableData *recordData;//录音文件


- (void)fillDataWithMessageType:(MessageType)type OrRecordData:(NSMutableData *)data OrImg:(UIImageView *)img ContentText:(NSString *)text photo:(UIImage *)photoImg;


- (void)upDateLoadingProgress;



@end
