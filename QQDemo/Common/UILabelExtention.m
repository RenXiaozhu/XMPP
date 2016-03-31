//
// Created by lijing on 15/6/17.
// Copyright (c) 2015 com.8f8. All rights reserved.
//

#import "UILabelExtention.h"


@implementation UILabel(BFBExtentsion)


- (void)setText:(NSString *)txt withLineSpace:(int)space {
    if (space > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = space;// 字体的行间距
        NSDictionary *attributes = @{
                NSParagraphStyleAttributeName:paragraphStyle
        };
        self.attributedText = [[NSAttributedString alloc] initWithString:txt attributes:attributes];
    } else {
        self.text = txt;
    }
}


@end