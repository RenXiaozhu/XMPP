//
//  CellShareModelView.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/3/30.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "CellShareModelView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "AudioStreamer.h"
#import "VideoPlayerStreamViewController.h"

@implementation CellShareModelView

@synthesize shareImg;
@synthesize shareContentLable;
@synthesize shareTitleLable;
@synthesize playerBtn;



- (id)initWithFrame:(CGRect)frame contentUrl:(NSString *)contentUrl
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUIwithModel:requestInfomationWithUrl(contentUrl)];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame shareModel:(ShareContentModel *)model
{

    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initUIwithModel:model];
    }
    
    return self;
    
}


ShareContentModel *(requestInfomationWithUrl)(NSString * contentUrl)
{
    ShareContentModel *model = [[ShareContentModel alloc]init];
    
    NSURL *url = [NSURL URLWithString:contentUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0];
    [request setHTTPMethod:@"POST"];
    
    NSError *error = [[NSError alloc]init];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    id myResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if ([myResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)myResult;
        
        model.shareContent     = [dict objectForKey:@"shareContent"];
        
        NSString *type = [dict objectForKey:@"audioType"];
        
        if ([type isEqualToString:@"TextType"])
        {
            model.shareContentType = TextType;
        }
        else if ([type isEqualToString:@"MusicType"])
        {
            model.shareContentType = MusicType;
        }
        else if ([type isEqualToString:@"ViedoType"])
        {
            model.shareContentType = ViedoType;
        }
        else if ([type isEqualToString:@"FileType"])
        {
            model.shareContentType = FileType;
        }
        else if ([type isEqualToString:@"PictureType"])
        {
            model.shareContentType = PictureType;
        }
        
        model.shareFrom        = [dict objectForKey:@"shareFrom"];
        model.shareImg         = [NSData dataWithContentsOfURL:[NSURL URLWithString:
                                 [dict objectForKey:@"shareImg"]]];;
        model.shareTitle       = [dict objectForKey:@"shareTitle"];
        model.contentUrl       = [dict objectForKey:@"contentUrl"];
    
    }
    return model;
}


- (void)initUIwithModel:(ShareContentModel *)model
{
    self.backgroundColor = [UIColor whiteColor];
    
    shareImg = [[UIImageView alloc]initWithImage:[UIImage imageWithData:model.shareImg]];
    shareImg.frame = CGRectMake(2, 5, self.frame.size.height-10, self.frame.size.height-10);
    [self addSubview:shareImg];
    
    playerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playerBtn.frame =CGRectMake(2, 5, self.frame.size.height-10, self.frame.size.height-10);
    
    switch (model.shareContentType) {
        case TextType:
        {
            [playerBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [playerBtn setBackgroundColor:[UIColor clearColor]];
            [playerBtn addTarget:self action:@selector(skipToWebView:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case MusicType:
        {
            [playerBtn setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
            [playerBtn setBackgroundColor:[UIColor clearColor]];
            [playerBtn addTarget:self action:@selector(playMusic: model:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case ViedoType:
        {
            [playerBtn setBackgroundImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
            [playerBtn setBackgroundColor:[UIColor clearColor]];
            [playerBtn addTarget:self action:@selector(playMedia: model:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case FileType:
        {
            
        }
            break;
        case PictureType:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}


- (void)skipToWebView:(UIButton *)btn model:(ShareContentModel *)model
{

}

- (void)playMusic:(UIButton *)btn model:(ShareContentModel *)model
{
    
    AudioStreamer *stream = [[AudioStreamer alloc]initWithURL:[NSURL URLWithString:model.contentUrl]];
    
    
    
    
}

- (void)playMedia:(UIButton *)btn  model:(ShareContentModel *)model
{

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
  
    
}


@end
