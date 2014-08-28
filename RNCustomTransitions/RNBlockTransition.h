//
//  RNBlockTransition.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 10/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNTransition.h"

@interface RNBlockTransition : RNTransition

+ (instancetype)transitionWithAnimation:(void (^)(UIView *fromView,
                                                  UIView *toView,
                                                  UIView *containerView,
                                                  void (^executeWhenAnimationIsCompleted)(BOOL finished)))animationBlock;

- (instancetype)initWithAnimation:(void (^)(UIView *fromView,
                                            UIView *toView,
                                            UIView *containerView,
                                            void (^executeWhenAnimationIsCompleted)(BOOL finished)))animationBlock;

@end
