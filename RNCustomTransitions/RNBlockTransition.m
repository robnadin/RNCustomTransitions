//
//  RNBlockTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 10/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNBlockTransition.h"

@interface RNBlockTransition ()

@property (nonatomic, copy) void (^animationBlock)(UIView *, UIView *, UIView *);

@end


@implementation RNBlockTransition

#pragma mark - Class Methods

+ (instancetype)transitionWithDuration:(NSTimeInterval)duration animations:(void (^)(UIView *, UIView *, UIView *))animations completion:(void (^)(BOOL))completion
{
    RNBlockTransition *transition = [[RNBlockTransition alloc] initWithDuration:duration animations:animations completion:completion];
    return transition;
}

#pragma mark - Init Methods

- (instancetype)initWithDuration:(NSTimeInterval)duration animations:(void (^)(UIView *, UIView *, UIView *))animations completion:(void (^)(BOOL))completion
{
    self = [super initWithDuration:duration completionBlock:completion];
    if (self) {
        _animationBlock = animations;
    }
    return self;
}

#pragma mark - Override Methods

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
        completionBlock:(void (^)(BOOL))completionBlock
{
    if (self.animationBlock) {
        self.animationBlock(fromView, toView, containerView);
    }
}

@end
