//
//  ChatListCell.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"
#import "PublicFile.h"

@interface ChatListCell : UITableViewCell
{
    UIView *bgTransView;
    UIImageView *photoImg;
    UILabel *titleLable;
    
    
    MessageType messageType;
}


@end
