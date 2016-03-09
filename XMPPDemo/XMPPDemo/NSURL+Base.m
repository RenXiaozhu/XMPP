//
//  NSURL+Base.m
//  HexunFund
//
//  Created by 宁采花 宁 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSURL+Base.h"


@implementation NSURL(BaseAdditions)

-(NSString *)URLStringWithoutQuery
{
	NSArray *parts=[[self absoluteString] componentsSeparatedByString:@"?"];
	return [parts objectAtIndex:0];
}

@end
