//
//  BasicAnimationBtn.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/6/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    KCBtnAnmationDefaultType = 1,
    KCBtnAnmationScaleType,
    KCBtnAnimationShakeType,
    KCBtnAnimationRotateType
    
} AnimationType;

@interface BasicAnimationBtn : UIButton
{
    BOOL  btnAnimation;
    BOOL  defaultAnimation;
    CGFloat BtnDuration;
    AnimationType animationType;
}

@property (nonatomic,assign) BOOL  btnAnimation;
@property (nonatomic,assign) BOOL  defaultAnimation;
@property (nonatomic,assign) CGFloat BtnDuration;
@property (nonatomic,assign) AnimationType animationType;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame AnimationType:(AnimationType)aType;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents animationWhenTouch:(BOOL)animation;

- (void)DefaultAnimation;

- (void)setDuration:(CGFloat)duration;

- (void)setAnimation:(BOOL)animation;


@end
