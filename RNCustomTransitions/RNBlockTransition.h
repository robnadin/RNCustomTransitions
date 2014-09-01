//
//  RNBlockTransition.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 10/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNTransition.h"

@interface RNBlockTransition : RNTransition

+ (instancetype)transitionWithDuration:(NSTimeInterval)duration
                            animations:(void (^)(UIView *fromView, UIView *toView, UIView *containerView))animations
                            completion:(void (^)(BOOL finished))completion;


- (instancetype)initWithDuration:(NSTimeInterval)duration
                      animations:(void (^)(UIView *fromView, UIView *toView, UIView *containerView))animations
                      completion:(void (^)(BOOL finished))completion;


@end
