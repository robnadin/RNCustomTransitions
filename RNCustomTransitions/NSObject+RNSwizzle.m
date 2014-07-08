//
//  NSObject+RNSwizzle.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+RNSwizzle.h"

#ifdef RNSwizzle_h

@implementation NSObject (RNSwizzle)

#pragma mark - Public Methods

+ (void)rn_swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)newSelector
{
    Class aClass = object_getClass(self);
    [self rn_swizzleMethod:originalSelector onClass:aClass withMethod:newSelector];
}

+ (void)rn_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)newSelector
{
    Class aClass = self.class;
    [self rn_swizzleMethod:originalSelector onClass:aClass withMethod:newSelector];
}

#pragma mark - Helper Methods

+ (void)rn_swizzleMethod:(SEL)originalSelector onClass:(Class)aClass withMethod:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, newSelector);

    BOOL didAddMethod = class_addMethod(aClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(aClass,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end


@implementation NSObject (RNSwizzleShorthand)

+ (void)swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)newSelector
{
    [self rn_swizzleClassMethod:originalSelector withMethod:newSelector];
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)newSelector
{
    [self rn_swizzleInstanceMethod:originalSelector withMethod:newSelector];
}

@end

#endif
