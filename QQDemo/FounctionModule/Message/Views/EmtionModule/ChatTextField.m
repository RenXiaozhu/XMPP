//
//  ChatTextField.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/26.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "ChatTextField.h"
@interface ChatTextField()
{
    CGRect keybordRect;
}
@end

@implementation ChatTextField
@synthesize isRoomChat;
@synthesize emoticonView;
@synthesize funcationModule;
@synthesize isShowEmoticonView;
@synthesize isShowFunctionView;
@synthesize inputTextField;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame isRoomChat:(BOOL)_isRoomChat
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initUIWithIsRoomChat:_isRoomChat];
    }
    return self;
}

- (void)initUIWithIsRoomChat:(BOOL)_isRoomChat
{
    self.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    [self initTextField];
    [self initLeftOrRightBtn];
    [self initEmoticon];
    [self regNotification];
}


- (void)initTextField
{
    inputTextField = [[UITextView alloc]initWithFrame:CGRectMake(60, 5, SCREEN_WIDTH-60-90, 30)];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.layer.masksToBounds = YES;
    inputTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    inputTextField.layer.borderWidth = 1.0f;
    inputTextField.layer.cornerRadius = 2.0f;
    inputTextField.textColor = [UIColor blackColor];
    inputTextField.font = [UIFont systemFontOfSize:14];
    inputTextField.delegate = self;
    [self addSubview:inputTextField];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat inputTextHeight = [self calculateHeightWithText:inputTextField.text];
    
    [UIView animateWithDuration:0.2 animations:^{
        if (inputTextHeight>30)
        {
            if (inputTextHeight<=100)
            {
                self.frame = CGRectMake(0, SCREEN_HEIGHT-20-inputTextHeight-keybordRect.size.height, SCREEN_WIDTH, 20+inputTextHeight);
                inputTextField.frame = CGRectMake(inputTextField.frame.origin.x, inputTextField.frame.origin.y, inputTextField.frame.size.width, inputTextHeight+10);
                for (Class view in self.subviews)
                {
                    if ([[view class] isSubclassOfClass:[UIView class]]&&view!=inputTextField)
                    {
                        UIView *ve = (UIView *)view;
                        ve.frame = CGRectMake(ve.frame.origin.x, self.bounds.size.height-40, ve.frame.size.width, 40);
                    }
                }

            }
            else
            {
                inputTextField.scrollEnabled = YES;
            }
            
        }
        else
        {
            self.frame = CGRectMake(0, SCREEN_HEIGHT-40-keybordRect.size.height, SCREEN_WIDTH, 40);
            inputTextField.frame = CGRectMake(inputTextField.frame.origin.x, inputTextField.frame.origin.y, inputTextField.frame.size.width, self.frame.size.height-10);
            inputTextField.scrollEnabled = NO;
            
            for (Class view in self.subviews)
            {
                if ([[view class] isSubclassOfClass:[UIView class]]&&view!=inputTextField)
                {
                    UIView *ve = (UIView *)view;
                    ve.frame = CGRectMake(ve.frame.origin.x, self.bounds.size.height-40, ve.frame.size.width, 40);
                }
            }
        }
        
    }];
    
}

- (CGFloat)calculateHeightWithText:(NSString *)text
{
    CGSize size;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >=70000)
    size = [text boundingRectWithSize:CGSizeMake(inputTextField.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
#else
    
    size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(inputTextField.bounds.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    return size.height;
}


- (void)initLeftOrRightBtn
{
    
    UIView *leftView = [[UIView alloc]initWithFrame:
                        CGRectMake(0, self.bounds.size.height-40, 50, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIButton *voiceChat = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceChat.frame = leftView.bounds;
    [voiceChat setTitle:@"语音" forState:UIControlStateNormal];
    [voiceChat setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [voiceChat addTarget:self action:@selector(startVoiceChat) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:voiceChat];
    [self addSubview:leftView];
    
    UIView *rightV = [[UIView alloc]initWithFrame:
                      CGRectMake( SCREEN_WIDTH-80, self.bounds.size.height-40, 80, 40)];
    rightV.backgroundColor = [UIColor clearColor];
    
    UIButton *emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emoticonBtn setFrame:CGRectMake(0, 0, rightV.bounds.size.width/2, rightV.bounds.size.height)];
    [emoticonBtn setTitle:@"表情" forState:UIControlStateNormal];
    [emoticonBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [emoticonBtn addTarget:self action:@selector(showOrHiddenEmoticonBorder:) forControlEvents:UIControlEventTouchUpInside];
    [rightV addSubview:emoticonBtn];
    
    UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [functionBtn setFrame:CGRectMake( rightV.bounds.size.width/2, 0, rightV.bounds.size.width/2, rightV.bounds.size.height)];
    [functionBtn setTitle:@"添加" forState:UIControlStateNormal];
    [functionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [functionBtn addTarget:self action:@selector(showOrHiddenEmoticonBorder:) forControlEvents:UIControlEventTouchUpInside];
    [rightV addSubview:functionBtn];
    
    [self addSubview:rightV];
    
    
}

- (void)startVoiceChat
{
    
}


- (void)showOrHiddenEmoticonBorder:(UIButton *)btn
{
//    [self.inputView removeFromSuperview];
    if (isShowEmoticonView)
    {
        inputTextField.inputView = nil;
        isShowEmoticonView = NO;
        [self reloadInputViews];
        [btn setTitle:@"表情" forState:UIControlStateNormal];
    }
    else
    {
        inputTextField.inputView = emoticonView;
        isShowEmoticonView = YES;
        [btn setTitle:@"键盘" forState:UIControlStateNormal];
    
    }
    [inputTextField reloadInputViews];
    [self performSelector:@selector(dlay) withObject:nil afterDelay:0.02f];
}

- (void)dlay
{
    [inputTextField becomeFirstResponder];
}

- (void)initEmoticon
{
    emoticonView = [[EmoticonView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    emoticonView.backgroundColor = [UIColor whiteColor];
    isShowEmoticonView = NO;
}

- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - notification handler

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    keybordRect = endKeyboardRect;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(self.frame.origin.x,SCREEN_HEIGHT-self.frame.size.height-endKeyboardRect.size.height, self.frame.size.width, self.frame.size.height);
    }];
   
}


- (void)UIKeyboardWillHideNotification:(NSNotification *)not
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(self.frame.origin.x,SCREEN_HEIGHT-40, self.frame.size.width, self.frame.size.height);
    }];
}


#pragma textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)dealloc
{
    [self unregNotification];
    emoticonView  = nil;
    
}

@end
