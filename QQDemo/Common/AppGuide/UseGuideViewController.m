

#import "UseGuideViewController.h"


@interface UseGuideViewController () <UIScrollViewDelegate>

@end

@implementation UseGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initWithGuideView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}
/**
 *  scrollView
 */
-(void)initWithGuideView
{
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.backgroundColor=[UIColor clearColor];
    scroll.bounces = NO;
    scroll.delegate=self;
    scroll.pagingEnabled = YES;
    scroll.scrollEnabled = YES;
    scroll.directionalLockEnabled = YES;

    for(int i=0;i<3;i++)
    {
        guideView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, self.view.frame.size.height)];
        guideView.tag = i+1;
        //if(i==0)
        NSString *imgName = [NSString stringWithFormat:@"intro%d", i+1];
        UIImage  *img= GET_IMAGE_FROM_BUNDLE_PATH(ADAPT_IMAGE_NAME(imgName) ,@"guide");
        guideView.image = img;
        guideView.userInteractionEnabled=YES;
        [scroll addSubview:guideView];
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH*(i+1), 0);
        if (guideView.tag==3)
        {
            UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDown)];
            [guideView addGestureRecognizer:tapGR];
        }
    }
        
    [self.view addSubview:scroll];
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50 ,SCREEN_WIDTH, 21)];
    pageControl.backgroundColor=[UIColor clearColor];
    pageControl.numberOfPages=3;
    pageControl.currentPage=0;
    [self.view addSubview:pageControl];

}
/**
 *  pageControl
 *
 *  @param scrollView scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = (int)floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
}
/**
 *  手势方法
 */
-(void)touchDown
{

//    [[AppContext sharedInstance] setLastInstalledAppVersion:APP_VERSION];
//    [[AppContext sharedInstance] setIsGuideFinished:YES];

    if ([self.delegate respondsToSelector:@selector(removeGuideView)])
    {
        [self.delegate removeGuideView];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
