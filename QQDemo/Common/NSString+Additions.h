//
//  NSString+Additions.h
//  HexunFund
//
//  Created by 宁采花 宁 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)


-(NSString *)URLEncodedString;
-(NSString *)URLDecodedString;
-(NSString *)URLEncoded4GBKString;
-(NSString *)URLDecoded4GBKString;
-(NSString *)Unicode2GBKString;

-(NSString*)encodeAsURIComponent;
-(NSString *)UTF8SpaceReplace;
-(time_t)toTime;

-(BOOL) isEmailAddress;

-(NSString *)float2String:(int)len;

@end
