//
//  UIView+RNViewRendering.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

#import "NSObject+RNSwizzle.h"

#import "UIView+RNViewRendering.h"

@implementation UIView (RNViewRendering)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(tintAdjustmentMode) withMethod:@selector(rn_tintAdjustmentMode)];
        [self swizzleInstanceMethod:@selector(setTintAdjustmentMode:) withMethod:@selector(rn_setTintAdjustmentMode:)];
    });
}

#pragma mark - Swizzled methods

- (UIViewTintAdjustmentMode)rn_tintAdjustmentMode
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        return [self rn_tintAdjustmentMode];
    } else {
        return 0;
    }
}

- (void)rn_setTintAdjustmentMode:(UIViewTintAdjustmentMode)tintAdjustmentMode
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [self rn_setTintAdjustmentMode:tintAdjustmentMode];
    }
}

@end
