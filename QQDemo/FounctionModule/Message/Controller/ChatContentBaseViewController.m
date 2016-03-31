//
//  ChatContentBaseViewController.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/22.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//



#import "ChatContentBaseViewController.h"
#import "XMPPManager.h"
@implementation heightModel :NSObject
@synthesize index = _index;
@synthesize height = _height;
@end

@implementation ChatContentBaseViewController
@synthesize inputTextView;
@synthesize postBtn;
@synthesize textLabel;
@synthesize turnSocket;
@synthesize emotconView;
@synthesize chatInputTextView;
@synthesize calculateQueue;

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor redColor];
    
    inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(100, 100+64, 200, 50)];
    inputTextView.delegate = self;
    inputTextView.editable =YES;
    [self.view addSubview:inputTextView];
    
    
    postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.exclusiveTouch = YES;
    postBtn.frame = CGRectMake(100, 170+64, 50, 25);
    [postBtn setTitle:@"发送" forState:UIControlStateNormal];
    [postBtn setBackgroundColor:[UIColor grayColor]];
    [postBtn addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 64, 200, 50)];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textColor  = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    
    __block ChatContentBaseViewController *baseView = self;
    
    XMPPManager *manage = [XMPPManager sharedManager];
    
    [manage setRecvMessageBlock:^(NSString *str1,NSString *str2){
        
        baseView.textLabel.text = str1;

    }];
    
//    emotconView = [[EmoticonView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
//    emotconView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:emotconView];
    
    chatInputTextView = [[ChatTextField alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40) isRoomChat:NO];
    [self.view addSubview:chatInputTextView];
    
}


- (void)postMessage
{
     XMPPManager *manage = [XMPPManager sharedManager];
    [manage sendMessage:inputTextView.text to:@"user1@hexun-pro.local" completion:^(NSString *str){
        DDLogInfo(@"%@",str);
    }];
}


- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    
}

- (void)turnSocketDidFail:(TURNSocket *)sender
{
    
}


#pragma mark - uitextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [chatInputTextView reloadInputViews];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [chatInputTextView.inputTextField resignFirstResponder];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}




- (void)initThreadCal
{
    calculateQueue = [NSOperationQueue currentQueue];
    [calculateQueue setMaxConcurrentOperationCount:3];

}


- (void)calculateHeightWithDataModel:(NSArray *)data targetObject:(NSMutableArray *)object
{
    for (int i = 0; i<data.count; i++)
    {
        heightModel *model = [[heightModel alloc]init];
        model.index = i;
        [object addObject:model];
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(calculateHeight: nsArr: arr:) object:object];
        [calculateQueue addOperation:operation];

    }
}

- (void)calculateHeight:(int)index  nsArr:(NSArray *)data  arr:(NSMutableArray *)objec
{
    CGFloat height = [self calculateHeightWithDataModel:[data objectAtIndex:index]];
    
    heightModel *model = [objec objectAtIndex:index];
    model.height = height;
    
}

- (CGFloat)calculateHeightWithDataModel:(id)objc
{
    CGFloat defaultHeight = 40;
    
    return defaultHeight;
}

@end
