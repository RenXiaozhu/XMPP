//
// Created by fengshuai on 16/2/27.
// Copyright (c) 2016 yundongsports.com. All rights reserved.
//

#import "WebViewController.h"
#import "HudHelper.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
//#import "LocalConfigData.h"


@interface WebViewController()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@end
@implementation WebViewController
{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _appendUserId=YES;

    _webView= [[UIWebView alloc] initWithFrame:CGRectMake(0,0,self.view.width,SCREEN_HEIGHT-CONTENT_NAVIGATIONBAR_HEIGHT-PHONE_STATUSBAR_HEIGHT)];
    [self.view addSubview:_webView];

    _progressProxy = [[NJKWebViewProgress alloc] init];

    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;

    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    if (_showShareAction)
    {
        self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    }

    if (_url.length)
    {
        NSMutableURLRequest *request= [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlByAppendingUserId] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];

        [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0];

        [_webView loadRequest:request];
    }

}

- (void)reload
{
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlByAppendingUserId] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];

    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0];

    [_webView loadRequest:request];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_progressView setProgress:1 animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[HudHelper getInstance] hideHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[HudHelper getInstance] hideHud];

    [_progressView setProgress:1 animated:YES];
    
    if([error code] == NSURLErrorCancelled)
    {
        return;
    }

    [[[UIAlertView alloc] initWithTitle:@"网页加载错误" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    // 在请求持续请求中返回不会隐藏
    [_progressView setProgress:progress animated:YES];
    NSString *title=[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length)
        self.title =title;
}

-(void)share
{
    //TODO:分享链接
}

-(NSString *)urlByAppendingUserId
{
    if (!_appendUserId)
        return _url;

    NSString *result=nil;

    if ([_url rangeOfString:@"?"].location==NSNotFound)
    {
//        result= [_url stringByAppendingFormat:@"?userid=%@", [LocalConfigData shareInstance].user.userid];
    }
    else
    {
//        result= [_url stringByAppendingFormat:@"&userid=%@", [LocalConfigData shareInstance].user.userid];
    }

    return result;
}

@end