//
//  NSDictionary+GetValue.m
//  HexunFund
//
//  Created by 宁采花 宁 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+GetValue.h"


@implementation NSDictionary (GetValueAdditions)

-(BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
	return [self objectForKey:key]==[NSNull null]? defaultValue:[[self objectForKey:key]boolValue];
}

-(int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
	return [self objectForKey:key]==[NSNull null]? defaultValue:[[self objectForKey:key]intValue];
}

-(time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
	NSString *stringTime=[self objectForKey:key];
	if ((id)stringTime==[NSNull null]) {
		stringTime=@"";
	}
	
	struct tm created;
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

-(long long)getLongLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue
{
	return [self objectForKey:key] == [NSNull null] ? defaultValue : [[self objectForKey:key] longLongValue];
}

-(NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
	return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] ? defaultValue : [self objectForKey:key];
}

@end
