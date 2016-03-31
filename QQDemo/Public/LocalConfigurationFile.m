//
//  LocalConfigurationFile.m
//  XMPPDemo
//
//  Created by Hexun pro on 15/4/29.
//  Copyright (c) 2015年 Hexun. All rights reserved.
//

#import "LocalConfigurationFile.h"

@implementation LocalConfigurationFile
@synthesize userAccount;
@synthesize userPassword;
@synthesize userToken;
@synthesize chatSoakBgType;
@synthesize accountGrade;
@synthesize chatViewBgType;
@synthesize appDressUpTypeName;

static LocalConfigurationFile *manager;
+ (LocalConfigurationFile *)shareManager
{
    if (manager==nil)
    {
       manager = [[super alloc]init];
    }
    return manager;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (!manager)
        {
            manager = [super allocWithZone:zone];
            return manager;
        }
        
    }
    return nil;
}


- (id)init
{
    @synchronized(self)
    {
        if (self = [super init])
        {
            [self initLocalData];
            
            return self;
        }
    }
    return nil;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//- (id)retain
//{
//    return self;
//}
//
//
//- (NSUInteger)retainCount
//{
//    return UINT_MAX;
//}
//
//
//- (id)autorelease
//{
//    return self;
//}
//
//
//- (oneway void)release
//{
//    
//}

- (void)initLocalData
{
    [self initDefaultEmoticon];
    
}


- (void)initDefaultEmoticon
{
    NSArray *array = [NSArray arrayWithObjects:
                      @"/惊讶",@"/撇嘴",@"/色",@"/发呆",
                      @"/酷",@"/害羞",@"/闭嘴",@"/睡",
                      @"/伤心",@"/尴尬",@"/发怒",@"/微笑",
                      @"",@"",@"",@"",@"",@"",@"",
                      @"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@""
                      ,@"",@"",@"",@"",@"",@"",@"",@"", nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    
}


@end
