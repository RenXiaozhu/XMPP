//
//  EmoticonView.h
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/26.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmoticonView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *EmoticonCollectionView;
    UIScrollView *bgScrollView;
    UIScrollView *toolBarScrollView;
    
    UIView *firstModuleView;           //经典表情部分
    UIScrollView *firstContentScrollView;//经典表情框
    UIScrollView *recentScrollView;    //最近表情框
    UIButton *recentEmoticonBtn;       //最近使用的表情btn
    UIButton *classicalEmoticonBtn;    //经典表情btn
    UIButton *bigEmoticonBtn;          //大表情
    UIButton *sendBtn;                 //发送
    
    UIView *secondModuleView;          //大表情部分
    UIScrollView *secContentScrollView;
    UIButton *backBtn;                 //返回按钮
    UIButton *addBtn;                  //添加按钮
    NSInteger selectIndex;             //toolbar里面的表情选择的index
 
    
    UIPageControl *pageControl;
    
    NSMutableArray *recentEmoticonList;
    NSMutableArray *localBigEmoticonList;
    
}

@property (nonatomic,retain) UICollectionView *EmoticonCollectionView;
@property (nonatomic,retain) UIScrollView *bgScrollView;
@property (nonatomic,retain) UIScrollView *firstContentScrollView;
@property (nonatomic,retain) UIScrollView *secContentScrollView;
@property (nonatomic,retain) UIScrollView *recentScrollView;
@property (nonatomic,retain) UIScrollView *toolBarScrollView;
@property (nonatomic,retain) UIView *firstModuleView;
@property (nonatomic,retain) UIButton *recentEmoticonBtn;
@property (nonatomic,retain) UIButton *classicalEmoticonBtn;
@property (nonatomic,retain) UIButton *bigEmoticonBtn;
@property (nonatomic,retain) UIButton *sendBtn;
@property (nonatomic,retain) UIView *secondModuleView;
@property (nonatomic,retain) UIButton *backBtn;
@property (nonatomic,retain) UIButton *addBtn;
@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,retain) UIPageControl *pageControl;

- (instancetype)initWithFrame:(CGRect)frame;


- (void)prepareFiles;

@end
