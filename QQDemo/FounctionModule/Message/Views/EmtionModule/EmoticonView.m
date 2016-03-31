//
//  EmoticonView.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/5/26.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "EmoticonView.h"
#import "EmoticonCollectionViewCell.h"

#import <zlib.h>
@implementation EmoticonView
@synthesize bgScrollView;
@synthesize firstContentScrollView;
@synthesize secContentScrollView;
@synthesize recentScrollView;
@synthesize toolBarScrollView;
@synthesize firstModuleView;
@synthesize recentEmoticonBtn;
@synthesize classicalEmoticonBtn;
@synthesize bigEmoticonBtn;
@synthesize sendBtn;
@synthesize secondModuleView;
@synthesize backBtn;
@synthesize addBtn;
@synthesize selectIndex;
@synthesize pageControl;
@synthesize EmoticonCollectionView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUIViews];
    }
    return self;
}


- (void)initUIViews
{
    bgScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, 200);
    bgScrollView.scrollEnabled = NO;
    [self addSubview:bgScrollView];
    
    [self initFirstModule];
    [self initSecondModule];
}


- (void)initFirstModule
{
    
    
    firstModuleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height)];
    firstModuleView.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:firstModuleView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    EmoticonCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160) collectionViewLayout:flowLayout];

    EmoticonCollectionView.pagingEnabled = YES;
    EmoticonCollectionView.backgroundColor = [UIColor clearColor];
    EmoticonCollectionView.delegate = self;
    EmoticonCollectionView.showsHorizontalScrollIndicator = NO;
    EmoticonCollectionView.dataSource = self;
    [firstModuleView addSubview:EmoticonCollectionView];
    
    [EmoticonCollectionView registerClass:[EmoticonCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [EmoticonCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReuseableView"];

    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 10)];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.numberOfPages = 6;
    pageControl.currentPage = 1;
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [firstModuleView addSubview:pageControl];
}


- (void)initSecondModule
{
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 21;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH)/7, 150/3);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    EmoticonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    
    if (cell.emoticonBtn==nil)
    {
        cell.emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.emoticonBtn.frame = cell.contentView.bounds;
        cell.emoticonBtn.userInteractionEnabled = NO;
//        cell.emoticonBtn.exclusiveTouch = YES;
        //    [cell.emoticonBtn setTitle:@"111" forState:UIControlStateNormal];
        [cell.emoticonBtn setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:cell.emoticonBtn];
    }
    
    NSString *imgName = [NSString stringWithFormat:@"%ld.gif",(int)indexPath.row+indexPath.section*21+1];
    pageControl.currentPage = indexPath.section;
    DDLogInfo(@"%@",imgName);
    [cell.emoticonBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    [cell sizeToFit];
    return cell;
}



//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResuableView" forIndexPath:indexPath];
//    return view;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)prepareFiles
{
    
}

//压缩
-(NSData *)compressData:(NSData *)uncompressedData
{
    if ([uncompressedData length] == 0) return uncompressedData;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[uncompressedData bytes];
    strm.avail_in = (unsigned int)[uncompressedData length];
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (unsigned int)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}


//解压缩
-(NSData *)uncompressZippedData:(NSData *)compressedData
{
    
    if ([compressedData length] == 0) return compressedData;
    
    unsigned full_length = [compressedData length];
    
    unsigned half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
        
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }    
}

@end
