

#import <UIKit/UIKit.h>


@protocol UseGuideDelegate <NSObject>

-(void)removeGuideView;

@end

@interface UseGuideViewController : UIViewController 
{
    int currentPage;
    UIPageControl *pageControl;
    UIImageView *guideView;
}
@property(assign,nonatomic) id<UseGuideDelegate> delegate;

@end
