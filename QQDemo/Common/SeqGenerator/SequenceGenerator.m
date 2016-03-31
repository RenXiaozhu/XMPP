//
// Created by fengshuai on 16/1/10.
// Copyright (c) 2016 yundongsports.com. All rights reserved.
//

#import "SequenceGenerator.h"


@implementation SequenceGenerator
{

}

+ (int)nextSeq
{
    int seq= [[NSUserDefaults standardUserDefaults] integerForKey:@"ActivitySequance"];
    seq++;
    if (seq>=100)
        seq=1;

    [[NSUserDefaults standardUserDefaults] setInteger:seq forKey:@"ActivitySequance"];

    return seq;
}

@end