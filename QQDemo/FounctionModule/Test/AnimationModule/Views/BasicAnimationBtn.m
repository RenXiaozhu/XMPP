//
//  BasicAnimationBtn.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "BasicAnimationBtn.h"
#import <ImageIO/ImageIO.h>
@interface BasicAnimationBtn ()
{
    CAShapeLayer * shapelayer;
    CAShapeLayer *layer1;
    CGFloat rectWith;
    UIControlEvents event;
}
@end

@implementation BasicAnimationBtn
@synthesize btnAnimation;
@synthesize BtnDuration;
@synthesize animationType;
@synthesize defaultAnimation;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
      
        [self DefaultAnimation];
        [self creatAnimation];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame AnimationType:(AnimationType)aType
{
    self  = [super initWithFrame:frame];
    if (self)
    {
        self.animationType = aType;
        rectWith = frame.size.width>frame.size.height?frame.size.height:frame.size.width;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self creatAnimation];
}

- (void)DefaultAnimation
{
    self.defaultAnimation = YES;
    self.btnAnimation     = YES;
    self.BtnDuration      = 0.5f;
    self.animationType    = KCBtnAnmationDefaultType;
}

- (void)setDuration:(CGFloat)duration
{
    self.BtnDuration = duration;
}

- (void)addTarget:(id)target
           action:(SEL)action
        forControlEvents:(UIControlEvents)controlEvents
        animationWhenTouch:(BOOL)animation
{
    self.btnAnimation = animation;
    event = controlEvents;
    [self addTarget:target action:action forControlEvents:controlEvents];
    if (animation)
    {
        [self addTarget:self action:@selector(implementAnimation) forControlEvents:controlEvents];
    }
}


- (void)initLayer
{
  
}


- (void)setAnimation:(BOOL)animation
{
    self.btnAnimation = animation;
    if (animation)
    {
        [self addTarget:self action:@selector(implementAnimation) forControlEvents:event];
    }
}

- (void)creatAnimation
{

//    if (self.imageView.image!=nil)
    {
 
        if (animationType)
        {
            [self setUpdateAnimationWithStyle:self.animationType];
        }
        else
        {
            DDLogInfo(@"未设置动画类型");
        }
    }
//    else
    {
        DDLogInfo(@"未设置图标");
    }
    
}


- (void)drawRect:(CGRect)rect
{
    [self setUpdateAnimationWithStyle:self.animationType];
}

- (void)setUpdateAnimationWithStyle:(AnimationType)AType
{
    

    switch (animationType)
    {
        case KCBtnAnmationDefaultType:
        {
            DDLogInfo(@"默认动画类型");
            if ([self.imageView.layer animationForKey:@"dftAnimation"])
            {
                [self.imageView.layer removeAnimationForKey:@"dftAnimation"];
            }
            [self creatJumpAnimation];
            //                    CAEmitterLayer
            
        }
            break;
        case KCBtnAnimationRotateType:
        {
            DDLogInfo(@"旋转动画类型");
            
            [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
            if ([self.layer animationForKey:@"rotateAnimation"])
            {
                [self.layer removeAnimationForKey:@"rotateAnimation"];
            }
            [self creatRotatePointLoadingAnimation];
        }
            break;
        case KCBtnAnimationShakeType:
        {
            DDLogInfo(@"摇晃动画类型");
        }
            break;
        case KCBtnAnmationScaleType:
        {
            DDLogInfo(@"缩放动画类型");
        }
            break;
        default:
            break;
    }

}


- (UIBezierPath*)creatPathWithCenter:(CGPoint)point
                              radius:(CGFloat)radius
                          startAngle:(CGFloat)startAngle
                            endAngle:(CGFloat)endAngle
                           clockwise:(BOOL)clockwise
{
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    
    return path1;
}


- (void)creatJumpAnimation
{
    CAKeyframeAnimation *dftAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    dftAnimation.removedOnCompletion = NO;
    
    CGPoint point = self.imageView.layer.position;
    NSValue *value1 = [NSValue valueWithCGPoint:point];
    NSValue *value2 = [NSValue valueWithCGPoint:
                       CGPointMake(point.x, point.y-50)];
    NSValue *value3 = [NSValue valueWithCGPoint:
                       CGPointMake(point.x, point.y-1)];
    NSValue *value4 = [NSValue valueWithCGPoint:
                       CGPointMake(point.x, point.y-30)];
    NSValue *value5 = [NSValue valueWithCGPoint:
                       CGPointMake(point.x, point.y)];
    NSValue *value6 = [NSValue valueWithCGPoint:
                       CGPointMake(point.x, point.y-10)];
    NSValue *value7 = [NSValue valueWithCGPoint:
                       CGPointMake(point.x, point.y)];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:
                           value1,value2,value3,value4,value5,
                           value6,value7,
                           nil];
    dftAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0],
                              [NSNumber numberWithFloat:0.2],
                              [NSNumber numberWithFloat:0.3],
                              [NSNumber numberWithFloat:0.4],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:0.6],
                              [NSNumber numberWithFloat:0.7],
                              ];
    dftAnimation.timingFunctions =
    @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]
      ];
    dftAnimation.repeatCount = 1;
    dftAnimation.autoreverses = NO;
    dftAnimation.calculationMode = kCAAnimationLinear;
    dftAnimation.duration = self.BtnDuration;
    dftAnimation.values = arr;
    [self.imageView.layer addAnimation:dftAnimation forKey:@"dftAnimation"];
}

//point raotate along arcPath
- (void)creatRotatePointLoadingAnimation
{
    shapelayer = [CAShapeLayer layer];
    shapelayer.frame = self.bounds;
    shapelayer.path = [self creatPathWithCenter:CGPointMake(shapelayer.position.x, shapelayer.position.y) radius:rectWith/2 startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
    [self.layer addSublayer:shapelayer];
    shapelayer.fillColor=[UIColor clearColor].CGColor;
    shapelayer.backgroundColor=[UIColor clearColor].CGColor;
    shapelayer.strokeColor=[UIColor lightGrayColor].CGColor;
    shapelayer.opacity=1.0;
    shapelayer.lineCap=kCALineCapRound;
    shapelayer.lineWidth=1.0;
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeEnd=1.0;
    
    layer1 = [CAShapeLayer layer];
    layer1.frame = self.bounds;
    layer1.path = [self creatPathWithCenter:CGPointMake(layer1.position.x, 0) radius:4 startAngle:0 endAngle:2*M_PI clockwise:NO].CGPath;
    [self.layer addSublayer:layer1];
    layer1.fillColor = [UIColor grayColor].CGColor;
    layer1.backgroundColor=[UIColor clearColor].CGColor;
    layer1.strokeColor=[UIColor lightGrayColor].CGColor;
    layer1.opacity=1.0;
    layer1.lineJoin = kCALineJoinRound;
    layer1.lineCap=kCALineCapRound;
    layer1.lineWidth=1.0;
    layer1.strokeStart = 0.0;
    layer1.strokeEnd=1.0;
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.path = shapelayer.path;
    rotateAnimation.rotationMode = kCAAnimationRotateAuto;
    [rotateAnimation setValue:(id)layer1.path forKeyPath:@"layer1.path"];
    rotateAnimation.keyTimes = @[[NSNumber numberWithFloat:self.BtnDuration],];
    rotateAnimation.timingFunctions =
    @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],];
    rotateAnimation.repeatCount = 1000;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.calculationMode = kCAAnimationPaced;
    rotateAnimation.duration = self.BtnDuration;
    [layer1 addAnimation:rotateAnimation forKey:@"rotateAnimation"];

}

- (void)implementAnimation
{
//    if (self.imageView.image!=nil)
    {
        [self setUpdateAnimationWithStyle:self.animationType];
        
    }
}

@end
