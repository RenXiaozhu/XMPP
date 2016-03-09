//
//  JMPasswordLineLayer.m
//  JuumanUIKITDemo
//
//  Created by juuman on 14-9-22.
//  Copyright (c) 2014年 juuman. All rights reserved.
//

#import "JMPasswordLineLayer.h"


@implementation JMPasswordLineLayer
@synthesize processPoint;
@synthesize nowPoint;


- (void)drawInContext:(CGContextRef)ctx
{
    /*
     enum CGLineJoin {
     kCGLineJoinMiter,
     kCGLineJoinRound,
     kCGLineJoinBevel
     };
     */
//    CGContextSetLineWidth(ctx, 40);
    
//    CGFloat *ColorComponents =(CGFloat *)CGColorGetComponents([[UIColor blueColor] CGColor]);
    CGContextSetRGBStrokeColor (ctx, 38/255.0, 167/255.0, 229/255.0, 0.5);
    //    CGContextMoveToPoint(ctx, processPoint.x,processPoint.y);
//    CGContextAddLineToPoint(ctx, processPoint.x, processPoint.y);
    CLog(@"x==%f,y==%f",processPoint.x,processPoint.y);

//    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    
//    CGContextSetLineCap(ctx , kCGLineCapSquare);
    
//    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, nowPoint.x, nowPoint.y);
    
    CGContextAddLineToPoint(ctx, processPoint.x, processPoint.y);
    
    CGContextSetLineWidth(ctx, 40);
    
    CGContextSetAlpha(ctx, 0.5);
    
//    CGContextSetStrokeColorWithColor(ctx, ln.lineColor.CGColor);
    
    CGContextStrokePath(ctx);
    
//    nowPoint = processPoint;
}

@end
