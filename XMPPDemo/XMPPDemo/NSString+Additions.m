//
//  NSString+Additions.m
//  HexunFund
//
//  Created by 宁采花 宁 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

-(NSString *)URLEncoded4GBKString
{
    NSString *result=(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																		 (CFStringRef)self,
																		 NULL,
																		 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                         kCFStringEncodingGB_18030_2000);
	[result autorelease];
	return result;

}

-(NSString *)URLDecoded4GBKString
{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingGB_18030_2000);
    [result autorelease];
	return result;	
	
}

-(NSString *)URLEncodedString
{
	NSString *result=(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																		 (CFStringRef)self,
																		 NULL,
																		 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                         kCFStringEncodingUTF8);
	[result autorelease];
	return result;
}

-(NSString *)URLDecodedString
{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;	
	
}

-(NSString*)encodeAsURIComponent
{
	const char *p=[self UTF8String];
	NSMutableString *result=[NSMutableString string];
	for (; *p!=0; p++) {
		unsigned char c=*p;
		if (('0' <= c && c <= '9') || ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || (c == '-' || c == '_'))
		{
			[result appendFormat:@"%c",c];
		}else {
			[result appendFormat:@"%%%02X",c];
		}
        
	}
	return result;
}

-(NSString *)Unicode2GBKString
{  
    
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];  
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];  
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];  
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];  
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData  
                                                           mutabilityOption:NSPropertyListImmutable   
                                                                     format:NULL  
                                                           errorDescription:NULL];  
    
    //NSLog(@"Output = %@", returnStr);  
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];  
}

-(NSString *)UTF8SpaceReplace
{
    char* utf8Replace = "\xe2\x80\x86\0";
    NSData* data = [NSData dataWithBytes:utf8Replace length:strlen(utf8Replace)];
    NSString* utf8_str_format = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString* mutableStr = [NSMutableString stringWithString:self];
    NSString * str =  [mutableStr stringByReplacingOccurrencesOfString:utf8_str_format withString:@""];
    [utf8_str_format  release];
    return str;
}

-(time_t)toTime
{
    struct tm created;
	if (strptime([self UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
        strptime([self UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        
        return mktime(&created);
    }
	return nil;
}

-(BOOL) isEmailAddress { 
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:self]; 
    
} 

-(NSString *)float2String:(int)len
{
    
    NSMutableString *ret=[[[NSMutableString alloc] initWithCapacity:6] autorelease];
    
    NSRange range=[self rangeOfString:@"."];
    if (range.length>0) {
        
        NSArray *temps=[self componentsSeparatedByString:@"."];
        [ret appendString:[temps objectAtIndex:0]];
        [ret appendString:@"."];
        
        NSString *xs=[temps objectAtIndex:1];
        
        int c=len-(int)[xs length];
        if (c>0) {
            [ret appendString:xs];
            for (int i=0; i<c; i++) {
                [ret appendString:@"0"];
            }
        }
        else
        {
            NSString *vv= [xs substringWithRange:NSMakeRange(0, len)];
            
            [ret appendString:vv];
        }
        
    }
    else
    {
        [ret appendString:self];
        [ret appendString:@"."];
        for (int i=0; i<len; i++) {
            [ret appendString:@"0"];
        }
    }
    
    return ret;
}

@end
