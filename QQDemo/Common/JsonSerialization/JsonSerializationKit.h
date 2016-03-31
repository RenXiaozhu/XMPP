//
//  JsonSerializationKit.h
//  JsonSerializationKit
//
//  Created by fengshuai on 14-8-7.
//  Copyright (c) 2014年 fengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Generalize

#define Generalize(objType) @protocol objType @end \
   @interface NSObject(objType)<objType> @end

Generalize(Ignore)
Generalize(Optional)


#endif





