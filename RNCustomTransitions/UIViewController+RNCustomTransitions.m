//
//  UIViewController+RNCustomTransitions.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+RNCustomTransitions.h"

@implementation UIViewController (RNCustomTransitions)

#pragma mark - Public Accessors

- (UIEdgeInsets)modalFrameInsets
{
    SEL selector = @selector(modalFrameInsets);
    return [objc_getAssociatedObject(self, selector) UIEdgeInsetsValue];
}

- (void)setModalFrameInsets:(UIEdgeInsets)insets
{
    SEL selector = @selector(modalFrameInsets);
    objc_setAssociatedObject(self, selector, [NSValue valueWithBytes:&insets objCType:@encode(UIEdgeInsets)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)modalCenterOffset
{
    SEL selector = @selector(modalCenterOffset);
    return [objc_getAssociatedObject(self, selector) CGPointValue];
}

- (void)setModalCenterOffset:(CGPoint)offset
{
    SEL selector = @selector(modalCenterOffset);
    objc_setAssociatedObject(self, selector, [NSValue valueWithBytes:&offset objCType:@encode(CGPoint)], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
