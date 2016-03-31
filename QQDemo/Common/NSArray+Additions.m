//
// Created by fengshuai on 13-6-25.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (void)perform:(SEL)selector
{
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator *e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]);)
    {
        if ([delegate respondsToSelector:selector])
        {
            SuppressPerformSelectorLeakWarning([delegate performSelector:selector]);
        }
    }
}


- (void)perform:(SEL)selector withObject:(id)p1
{
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator *e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]);)
    {
        if ([delegate respondsToSelector:selector])
        {
            SuppressPerformSelectorLeakWarning([delegate performSelector:selector withObject:p1]);
        }
    }
}


- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2
{
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator *e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]);)
    {
        if ([delegate respondsToSelector:selector])
        {
            SuppressPerformSelectorLeakWarning([delegate performSelector:selector withObject:p1 withObject:p2]);
        }
    }
}


- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
{
//    NSArray *copy = [[NSArray alloc] initWithArray:self];
//    NSEnumerator* e = [copy objectEnumerator];
//    for (id delegate; (delegate = [e nextObject]); ) {
//        if ([delegate respondsToSelector:selector]) {
//            [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
//        }
//    }
//    [copy release];
}


- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2
{
    for (id delegate in self)
    {
        SuppressPerformSelectorLeakWarning([delegate performSelector:selector withObject:p1 withObject:p2]);
    }
}


- (void)makeObjectsPerformSelector:(SEL)selector
                        withObject:(id)p1
                        withObject:(id)p2
                        withObject:(id)p3
{
//    for (id delegate in self) {
//        [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
//    }
}


- (id)objectWithValue:(id)value forKey:(id)key
{
    for (id object in self)
    {
        id propertyValue = [object valueForKey:key];
        if ([propertyValue isEqual:value])
        {
            return object;
        }
    }
    return nil;
}


- (id)objectWithClass:(Class)cls
{
    for (id object in self)
    {
        if ([object isKindOfClass:cls])
        {
            return object;
        }
    }
    return nil;
}


- (BOOL)containsObject:(id)object withSelector:(SEL)selector
{
    for (id item in self)
    {
        id result;
        SuppressPerformSelectorLeakWarning(result = [item performSelector:selector withObject:object]);
        if ([result boolValue])
        {
            return YES;
        }
    }
    return NO;
}

@end
