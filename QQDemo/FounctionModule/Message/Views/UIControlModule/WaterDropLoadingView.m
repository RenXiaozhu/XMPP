//
//  WaterDropLoadingView.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/7.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "WaterDropLoadingView.h"
#import "UIView+ZXQuartz.h"

#define UpCircleZoomSpeed  120
#define DownCircleZoomSpeed  100
#define OffSetMaxValue     50
@interface WaterDropLoadingView()
{
    CGFloat upCircleRadius;
    CGFloat downCircleRadius;
}
@end

@implementation WaterDropLoadingView
@synthesize activityView;
@synthesize refreshImg;
@synthesize state;
@synthesize changTableViewStateBlock;
@synthesize tipLabel;


- (void)dealloc
{
//    [activityView release];
//    [refreshImg release];
//    Block_release(changTableViewStateBlock);
//    [tipLabel release];
//    [super dealloc];
}

- (id)initDefaultViewWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self)
    {
        upCircleRadius = 17.0;
        downCircleRadius = 17.0;
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(SCREEN_WIDTH/2-10, 10, 20, 20);
        [self addSubview:activityView];
        [activityView setHidden:YES];
        [activityView setHidesWhenStopped:YES];
        
        tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 35, 100, 15)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tipLabel];
        [tipLabel setHidden:YES];
    
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame refreshImg:(NSString *)refreshImg
{
    self = [super initWithFrame:frame];
    if (self)
    {
        upCircleRadius = 17.0;
        downCircleRadius = 17.0;
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(SCREEN_WIDTH/2-10, 10, 20, 20);
        [self addSubview:activityView];
        [activityView setHidden:YES];
        [activityView setHidesWhenStopped:YES];
        
        tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 35, 100, 15)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tipLabel];
        [tipLabel setHidden:YES];
    }
    return self;
}


- (void)drawViewWithOffset:(CGFloat)height
{
    
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    UIImage *refreshBtn = [UIImage imageNamed:@"refresh"];
    
    if (!state||state !=NSLoadingViewInLoadingDataState)
    {
        state = [self getLoadingStateWithHeight:height];
    }
    else if (state == NSLoadingViewInLoadingDataState)
    {
        state = NSLoadingViewInLoadingDataState;
    }
    
    
    switch (state) {
        case NSLoadingViewNomalState:
        {
            
            [self drawCircleWithCenter:CGPointMake(self.bounds.size.width/2, 27) radius:17];
            CGContextSetStrokeColorWithColor(cxt, [UIColor grayColor].CGColor);
            CGContextSetFillColorWithColor(cxt, [UIColor grayColor].CGColor);
            CGContextDrawImage(cxt, CGRectMake(self.bounds.size.width/2-15, 12, 30, 30), refreshBtn.CGImage);
        }
            break;
        case NSLoadingViewDragingState:
        {
            CGMutablePathRef path = [self getNowPathWithHeight:height];
            CGContextSetStrokeColorWithColor(cxt, [UIColor grayColor].CGColor);
            CGContextSetFillColorWithColor(cxt, [UIColor grayColor].CGColor);
            CGContextAddPath(cxt, path);
            CGContextDrawPath(cxt, kCGPathFillStroke);
            
            CGFloat scale = 1-height/DownCircleZoomSpeed;
            CGContextDrawImage(cxt, CGRectMake(self.bounds.size.width/2-15*scale, 15*(1+height/DownCircleZoomSpeed), 30*scale, 30*scale), refreshBtn.CGImage);
        }
            break;
        case NSLoadingViewInLoadingDataState:
        {
            [activityView startAnimating];
            [activityView setHidden:NO];
            tipLabel.hidden = YES;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 50);
            self.changTableViewStateBlock(NSLoadingViewInLoadingDataState);
        }
            break;
            
        case NSLoadingViewFinishedLoadDataState:
        {
            [self setNeedsDisplay];
        }
            break;
        case NSLoadingViewErrorLoadDataState:
        {
            [activityView startAnimating];
            [activityView setHidden:YES];
            tipLabel.hidden = NO;
            tipLabel.text = @"加载失败，稍后再试";
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 50);
            self.changTableViewStateBlock(NSLoadingViewInLoadingDataState);
        }
            break;
    
        default:
            break;
    }
    
}

- (void)upDateLoadingStateWithState:(LoadingState)loadingState
{
    switch (loadingState)
    {
        case NSLoadingViewInLoadingDataState:
        {
            [activityView startAnimating];
            [activityView setHidden:NO];
            tipLabel.hidden = YES;
            self.changTableViewStateBlock(NSLoadingViewInLoadingDataState);
        }
            break;
        case NSLoadingViewFinishedLoadDataState:
        {
            [activityView stopAnimating];
            [activityView setHidden:YES];
            tipLabel.hidden = NO;
            tipLabel.text = @"刷新成功!";
            self.changTableViewStateBlock(NSLoadingViewFinishedLoadDataState);
        }
            break;
        case NSLoadingViewErrorLoadDataState:
        {
            [activityView stopAnimating];
            [activityView setHidden:YES];
            tipLabel.hidden = NO;
            tipLabel.text = @"刷新失败!";
            self.changTableViewStateBlock(NSLoadingViewErrorLoadDataState);
        }
            break;
        default:
            break;
    }


}

- (void)drawRect:(CGRect)rect
{
    DDLogInfo(@"rect.size.height=%f",rect.size.height);
    [self drawViewWithOffset:rect.size.height-OffSetMaxValue];
}

- (CGMutablePathRef)getNowPathWithHeight:(CGFloat)height
{
    CGMutablePathRef path = CGPathCreateMutable();
    
        upCircleRadius = 17*(1-height/UpCircleZoomSpeed);
        downCircleRadius = 17*((1-height/DownCircleZoomSpeed)*(1-height/DownCircleZoomSpeed));
        CGPathAddArc(path, &CGAffineTransformIdentity, self.bounds.size.width/2, 30, upCircleRadius, 0, M_PI, YES);
     
//        CGPoint point1 = CGPointMake(self.bounds.size.width/2-upCircleRadius, 30);
        CGPoint point2 = CGPointMake(self.bounds.size.width/2-downCircleRadius, 30+height);
        CGPoint point3 = CGPointMake(self.bounds.size.width/2-upCircleRadius*upCircleRadius/17, 30+height*(upCircleRadius/17));
        CGPathAddQuadCurveToPoint(path, &CGAffineTransformIdentity, point3.x, point3.y, point2.x, point2.y);
//        (path, &CGAffineTransformIdentity, point1.x, point1.y, point3.x, point3.y, point2.x, point2.y)
    
        
        CGPoint point4 = CGPointMake(self.bounds.size.width/2+upCircleRadius, 30);
        CGPoint point5 = CGPointMake(self.bounds.size.width/2+downCircleRadius, 30+height);
        CGPoint point6 = CGPointMake(self.bounds.size.width/2+upCircleRadius*upCircleRadius/17, 30+height*(upCircleRadius/17));
        
//        CGAffineTransform form = CGAffineTransformMake(1,0,0,-1,point4.x ,point4.y);
        
        CGPathAddArc(path, &CGAffineTransformIdentity, self.bounds.size.width/2, 30+height, downCircleRadius, -M_PI, 0, YES);
        
        CGPathMoveToPoint(path, &CGAffineTransformIdentity, point4.x, point4.y);
        CGPathAddQuadCurveToPoint(path, &CGAffineTransformIdentity, point6.x, point6.y, point5.x, point5.y);
        //(path, &CGAffineTransformIdentity, point4.x, point4.y, point6.x, point6.y, point5.x, point5.y)
    CGPathCloseSubpath(path);
//    CGPathRelease(path);
    return path;
}

- (LoadingState)getLoadingStateWithHeight:(CGFloat)height
{
    LoadingState tmpState;
    if (height<0)
    {
        tmpState = NSLoadingViewNomalState;
    }
    else if (height>=0&&height<50)
    {
        tmpState = NSLoadingViewDragingState;
    }
    else if(height>=50)
    {
        tmpState = NSLoadingViewInLoadingDataState;
    }
    else
    {
        tmpState = NSLoadingViewInLoadingDataState;
    }
    
    return tmpState;
}

@end
