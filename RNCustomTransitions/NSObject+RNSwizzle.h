//
//  NSObject+RNSwizzle.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

@import Foundation;

#ifndef RNSwizzle_h
#define RNSwizzle_h

@interface NSObject (RNSwizzle)

+ (void)rn_swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)newSelector;
+ (void)rn_swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)newSelector;

@end


@interface NSObject (RNSwizzleShorthand)

+ (void)swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)newSelector;
+ (void)swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)newSelector;

@end

#endif
