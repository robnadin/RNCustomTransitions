//
//  RNBlockTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 10/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNBlockTransition.h"

@interface RNBlockTransition ()

@property (nonatomic, copy) void (^animationBlock)(UIView *, UIView *, UIView *, void (^)(BOOL));

@end


@implementation RNBlockTransition

#pragma mark - Class Methods

+ (instancetype)transitionWithDuration:(NSTimeInterval)duration animations:(void (^)(UIView *, UIView *, UIView *, void (^)(BOOL)))animations
{
    RNBlockTransition *transition = [[super alloc] initWithDuration:duration completionBlock:nil];
    transition.animationBlock = animations;

    return transition;
}

#pragma mark - Init Methods

- (instancetype)initWithDuration:(NSTimeInterval)duration animations:(void (^)(UIView *, UIView *, UIView *, void (^)(BOOL)))animations
{
    return [self.class transitionWithDuration:duration animations:animations];
}

#pragma mark - Override methods

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
    executeOnCompletion:(void (^)(BOOL))onCompletion
{
    if (self.animationBlock) {
        self.animationBlock(fromView, toView, containerView, onCompletion);
    }
}

@end
