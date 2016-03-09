//
//  UILabel+MyLable.m
//  HexunFund
//
//  Created by Hexun pro on 14-5-29.
//
//

#import "UILabel+MyLable.h"

@implementation UILabel (MyLable)


- (id)initWithFrame:(CGRect)frame bgColor:(UIColor *)color font:(UIFont *)font textColor:(UIColor *)textColor Aligent:(NSTextAlignment)aligent{
    self=[self initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=color;
        
        self.font=font;
        
        self.textColor=textColor;
        
        self.textAlignment=aligent;
        
        
    }
    
    return self;

}

@end
