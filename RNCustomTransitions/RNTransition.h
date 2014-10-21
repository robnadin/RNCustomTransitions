//
//  RNTransition.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 08/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

@import UIKit;

@interface RNTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic, readonly) NSTimeInterval duration;
@property (copy, nonatomic) void (^completionBlock)(BOOL);
@property (strong, nonatomic) RNTransition *reverseTransition;
@property (nonatomic) UIModalPresentationStyle presentationStyle;
@property (nonatomic) BOOL reverse;

+ (instancetype)transitionWithDuration:(NSTimeInterval)duration completionBlock:(void (^)(BOOL finished))completionBlock;

- (instancetype)initWithDuration:(NSTimeInterval)duration completionBlock:(void (^)(BOOL finished))completionBlock;

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
        completionBlock:(void (^)(BOOL finished))completionBlock NS_DEPRECATED_IOS(7_0, 8_0);

- (void)animateFromViewController:(UIViewController *)fromViewController
                 toViewController:(UIViewController *)toViewController
                   presentingView:(UIView *)presentingView
                    presentedView:(UIView *)presentedView
                    containerView:(UIView *)containerView
                  completionBlock:(void (^)(BOOL finished))completionBlock;

#pragma mark - Autocomplete

- (void)setCompletionBlock:(void (^)(BOOL finished))completionBlock;

@end
