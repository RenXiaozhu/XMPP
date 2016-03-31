//
//  NSDictionary+GetValue.h
//  HexunFund
//
//  Created by 宁采花 宁 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (GetValueAdditions)

-(BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
-(int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
-(time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
-(long long)getLongLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
-(NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

@end
