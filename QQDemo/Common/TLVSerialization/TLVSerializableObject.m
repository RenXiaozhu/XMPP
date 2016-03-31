//
// Created by fengshuai on 15/10/24.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import "TLVSerializableObject.h"
#import "TLVSerializationHelper.h"


@implementation SampleTLV
@end

@implementation TLVSerializableObject
{

}

- (instancetype)initWithData:(NSData *)data
{
    if (self=[super init])
    {
        [[TLVSerializationHelper sharedInstance] importData:data toObject:self];
    }

    return self;
}

- (NSData *)serializeToData
{
    return [[TLVSerializationHelper sharedInstance] serializeFromObject:self];
}

@end