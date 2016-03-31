//
//  HudHelper.m
//
//  Created by  on 12-2-24.
//

#import "HudHelper.h"

static HudHelper * instance = nil;

static const CGFloat kProgressMin = 0.01f;

@interface HudHelper (Private)

- (void)setHudCaption:(NSString*)caption image:(UIImage*)image acitivity:(BOOL)bAcitve;
- (void)showHudAutoHideAfter:(NSTimeInterval)time;

- (void)hideHudTime:(NSString*)obj;

@end

@interface HudHelper ()
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL actionCallBack;
@property (nonatomic, copy) NSString* showingCaption;
//@property (nonatomic, assign) NSInteger tag;
@end

@implementation HudHelper


@synthesize hud = _hud;
@synthesize showingCaption = _showingCaption;

//@synthesize tag = _tag;

+ (HudHelper *) getInstance
{
    @synchronized(self){
        if (!instance) {
            instance = [[HudHelper alloc] init];
        }
        return instance;
    }
}

- (id) init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    self.target = nil;
    self.actionCallBack = nil;

    [self hideHud];
}

#pragma mark - public method
// 在window上显示hud
- (void)showHudOnWindow:(NSString*)caption
                  image:(UIImage*)image
              acitivity:(BOOL)bAcitve
           autoHideTime:(NSTimeInterval)time
{
    [self setHudCaption:caption image:image acitivity:bAcitve];
    [self.hud setAccessoryPosition:ATMHudAccessoryPositionTop];

//    UIApplicationDelegate app = [UIApplication sharedApplication].delegate;
    [[UIApplication sharedApplication].delegate.window addSubview:self.hud.view];

    [self showHudAutoHideAfter:time];
}

// 在当前的view上显示hud
- (void)showHudOnView:(UIView*)view
              caption:(NSString*)caption
                image:(UIImage*)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
{
    [self setHudCaption:caption image:image acitivity:bAcitve];
    [self.hud setAccessoryPosition:ATMHudAccessoryPositionTop];

    self.hud.view.frame=view.bounds;
    [view addSubview:self.hud.view];

    [self showHudAutoHideAfter:time];
}


- (void)showHudOnView:(UIView*)view
              caption:(NSString*)caption
                image:(UIImage*)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
               target:(id)aTarget
             selector:(SEL)aSelector
{
    [self setHudCaption:caption image:image acitivity:bAcitve];
    [self.hud setAccessoryPosition:ATMHudAccessoryPositionTop];

    self.hud.view.frame=view.bounds;
    [view addSubview:self.hud.view];
    self.target = aTarget;
    self.actionCallBack = aSelector;

    [self showHudAutoHideAfter:time];
}

- (void)showProgressHudOnView:(UIView*)view
                      caption:(NSString*)caption
                        image:(UIImage*)image
                    acitivity:(BOOL)bAcitve
                 autoHideTime:(NSTimeInterval)time
{
    [self setHudCaption:caption image:image acitivity:bAcitve];
    [self.hud setAccessoryPosition:ATMHudAccessoryPositionTop];
    self.hud.view.frame=view.bounds;
    [view addSubview:self.hud.view];
    [self.hud setProgress:kProgressMin];
    [self showHudAutoHideAfter:time];
}

- (void)showDownloadProgressHudOnView:(UIView*)view
                              caption:(NSString*)caption
                                image:(UIImage*)image
                            acitivity:(BOOL)bAcitve
                         autoHideTime:(NSTimeInterval)time
                                  tag:(NSInteger)tag
{
    [self showDownloadProgressHudOnView:view
                                caption:caption
                                  image:image
                              acitivity:bAcitve
                           autoHideTime:time];
}

- (void)showDownloadProgressHudOnView:(UIView*)view
                              caption:(NSString*)caption
                                image:(UIImage*)image
                            acitivity:(BOOL)bAcitve
                         autoHideTime:(NSTimeInterval)time
{
    [self setHudCaption:caption image:image acitivity:bAcitve];
    [self.hud setAccessoryPosition:ATMHudAccessoryPositionCustom];
    self.hud.view.frame=view.bounds;
    [view addSubview:self.hud.view];
    [self.hud setProgress:kProgressMin];
    [self showHudAutoHideAfter:time];

}

- (void)updateProress:(CGFloat)progress forCation:(NSString*)caption
{
    if (self.hud != nil) {
        if (progress < kProgressMin) {
            progress = kProgressMin;
        }
        [self.hud setActivity:NO];
        [self.hud setCaption:caption];
        [self.hud setProgress:progress];
        [self.hud update];
    }
}

- (void)enableSuperViewInteraction:(BOOL)enable
{
    self.hud.allowSuperviewInteraction = enable;
}

// 隐藏hud
- (void)hideHud
{
    self.showingCaption = nil;
    if(self.hud != nil)
    {
        [self.hud setProgress:0.0f];
        [self.hud.view removeFromSuperview];
        [self.hud hide];
        self.hud = nil;
    }
    if (self.target != nil && self.actionCallBack != nil) {
        if ([self.target respondsToSelector:self.actionCallBack])
        {
            _Pragma("clang diagnostic push") 
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
            [self.target performSelector:self.actionCallBack];
            _Pragma("clang diagnostic pop")
        }

    }
    self.target = nil;
    self.actionCallBack = nil;
}

- (void)hideHudTime:(NSString*)obj
{
    if (self.showingCaption != nil && [self.showingCaption isEqualToString:obj]) {
        [self hideHud];
    }
}

- (void)hideHudAfter:(NSTimeInterval)time
{
    NSString* obj = [self.showingCaption copy];
    [self performSelector:@selector(hideHudTime:) withObject:obj afterDelay:time];
}

#pragma mark - private method

- (void)setHudCaption:(NSString*)caption image:(UIImage*)image acitivity:(BOOL)bAcitve
{
    // 强制清除一下
    [self hideHud];
    self.showingCaption = caption;
    self.hud = [[ATMHud alloc] initWithDelegate:nil];
    if (image != nil) {
        [self.hud setImage:image];
    }

    [self.hud setCaption:caption];

    if (bAcitve) {
        [self.hud setActivity:YES];
        [self.hud setActivityStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
}

- (void)showHudAutoHideAfter:(NSTimeInterval)time
{
    [self.hud show];

    if (time > 0.0f) {
        [self hideHudAfter:time];
    }
}


@end
