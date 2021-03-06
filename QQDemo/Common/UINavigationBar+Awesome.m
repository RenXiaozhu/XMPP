//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>
#import "UIImage+ImageEffects.h"

@implementation UINavigationBar (Awesome)
static char overlayKey;
static char emptyImageKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)emptyImage
{
    return objc_getAssociatedObject(self, &emptyImageKey);
}

- (void)setEmptyImage:(UIImage *)image
{
    objc_setAssociatedObject(self, &emptyImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//带高斯模糊效果
- (void)lt_setImgEffectBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        UIImage *img1 = [UIImage new];
        UIImage *img2 = [UIImage new];
        [self setBackgroundImage:[img1 applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:1 alpha:0.5] saturationDeltaFactor:1.0 maskImage:nil] forBarMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[img1 applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:1 alpha:0.5] saturationDeltaFactor:1.0 maskImage:nil] forBarMetrics:UIBarMetricsLandscapePhone];
        [self setShadowImage:[img2 applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:1 alpha:0.5] saturationDeltaFactor:1.0 maskImage:nil]];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

//纯颜色
- (void)lt_setPurBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        UIImage *img1 = [UIImage new];
        UIImage *img2 = [UIImage new];
        [self setBackgroundImage:img1 forBarMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:img1 forBarMetrics:UIBarMetricsLandscapePhone];
        [self setShadowImage:img2];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setContentAlpha:(CGFloat)alpha
{
    if (!self.overlay) {
        [self lt_setImgEffectBackgroundColor:self.barTintColor];
    }
    [self setAlpha:alpha forSubviewsOfView:self];
    if (alpha == 1) {
        if (!self.emptyImage) {
            self.emptyImage = [UIImage new];
        }
        self.backIndicatorImage = self.emptyImage;
    }
}

- (void)setAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if (subview == self.overlay) {
            continue;
        }
        subview.alpha = alpha;
        [self setAlpha:alpha forSubviewsOfView:subview];
    }
}

- (void)lt_reset
{
    [self setBackIndicatorImage:nil];
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsLandscapePhone];
    [self setShadowImage:nil];

    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
