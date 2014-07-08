//
//  UIViewController+RNCustomTransitions.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

#import <objc/runtime.h>

#import "RNCategoryProperties.h"

#import "NSObject+RNSwizzle.h"
#import "RNCustomTransitionSegue.h"

#import "UIViewController+RNCustomTransitions.h"
#import "RNTransitionContext.h"
#import "RNTransition.h"

typedef void (^SetAssociatedObjectBlock)(id obj);


@protocol RNModalViewControllerDelegate <NSObject>

- (void)rn_dismissModalViewController;

@end


@implementation UIViewController (RNCustomTransitions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(transitioningDelegate) withMethod:@selector(rn_transitioningDelegate)];
        [self swizzleInstanceMethod:@selector(setTransitioningDelegate:) withMethod:@selector(rn_setTransitioningDelegate:)];
        [self swizzleInstanceMethod:@selector(presentViewController:animated:completion:) withMethod:@selector(rn_presentViewController:animated:completion:)];
        [self swizzleInstanceMethod:@selector(dismissViewControllerAnimated:completion:) withMethod:@selector(rn_dismissViewControllerAnimated:completion:)];
        [self swizzleInstanceMethod:@selector(segueForUnwindingToViewController:fromViewController:identifier:) withMethod:@selector(rn_segueForUnwindingToViewController:fromViewController:identifier:)];
    });
}

#pragma mark - Swizzled methods

- (id<UIViewControllerTransitioningDelegate>)rn_transitioningDelegate
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        // Business as usual...
        return [self rn_transitioningDelegate];
    } else {
        return objc_getAssociatedObject(self, @selector(transitioningDelegate));
    }
}

- (void)rn_setTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        // Business as usual...
        [self rn_setTransitioningDelegate:transitioningDelegate];
    } else {
        objc_setAssociatedObject(self, @selector(transitioningDelegate), transitioningDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)rn_presentViewController:(UIViewController *)viewControllerToPresent
                        animated:(BOOL)flag
                      completion:(void (^)(void))completion
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 ||
        viewControllerToPresent.modalPresentationStyle != UIModalPresentationCustom) {
        // Business as usual...
        [self rn_presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        // TODO: The delegate is set to self... i.e. the source view controller
        id<UIViewControllerTransitioningDelegate> delegate = [viewControllerToPresent transitioningDelegate];

        if ([delegate respondsToSelector:@selector(animationControllerForPresentedController:presentingController:sourceController:)]) {
            // Retrieve the animated controller from the transitioning delegate
            RNTransition *animation = [delegate animationControllerForPresentedController:viewControllerToPresent
                                                                     presentingController:self
                                                                         sourceController:self];

            // Create custom transition context
            RNTransitionContext *context = [[RNTransitionContext alloc] initWithFromViewController:self
                                                                                  toViewController:viewControllerToPresent];

            // Set the modal delegate
//            viewControllerToPresent.rn_modalDelegate = (id<RNModalViewControllerDelegate>)self;

            // Overwrite the completion block
            __weak void (^weakBlock)(BOOL) = animation.completionBlock;
            animation.completionBlock = ^(BOOL finished) {
//                viewControllerToPresent.modalPresentationStyle = UIModalPresentationCurrentContext;
//                viewControllerToPresent.modalPresentationStyle = UIModalPresentationFormSheet;
                [self rn_presentViewController:viewControllerToPresent animated:NO completion:^{
                    void (^completionBlock)(BOOL) = weakBlock;
                    if (completionBlock) {
                        completionBlock(finished);
                    }
                }];
            };

            // Animate the transition using the context
            [animation animateTransition:context];
        }
    }
}

- (void)rn_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 ||
        self.modalPresentationStyle != UIModalPresentationCustom) {
        // Business as usual...
        [self rn_dismissViewControllerAnimated:flag completion:completion];
    } else {
        if ([self.transitioningDelegate respondsToSelector:@selector(animationControllerForDismissedController:)]) {
            // Retrieve the animated controller from the transitioning delegate
            RNTransition *animation = [self.transitioningDelegate animationControllerForDismissedController:self.presentedViewController];

            // Create custom transition context
            RNTransitionContext *context = [[RNTransitionContext alloc] initWithFromViewController:self.presentedViewController
                                                                                  toViewController:self];

            // Overwrite the completion block
            __weak void (^weakBlock)(BOOL) = animation.completionBlock;
            animation.completionBlock = ^(BOOL finished) {
                [self rn_dismissViewControllerAnimated:NO completion:^{
                    void (^completionBlock)(BOOL) = weakBlock;
                    if (completionBlock) {
                        completionBlock(finished);
                    }
                }];
            };

            // Animate the transition using the context
            [animation animateTransition:context];
        }
    }
}

- (void)rn_dismissModalViewController
{
    [self rn_dismissViewControllerAnimated:YES completion:nil];
}

- (UIStoryboardSegue *)rn_segueForUnwindingToViewController:(UIViewController *)toViewController
                                         fromViewController:(UIViewController *)fromViewController
                                                 identifier:(NSString *)identifier
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 ||
        fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
        // Business as usual...
        return [self rn_segueForUnwindingToViewController:toViewController
                                       fromViewController:fromViewController
                                               identifier:identifier];
    } else {
        RNCustomTransitionSegue *segue = [[RNCustomTransitionSegue alloc] initWithIdentifier:identifier
                                                                                      source:fromViewController
                                                                                 destination:toViewController];
        segue.unwind = YES;

        return segue;
    }
}

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

#pragma mark - Helper methods

//- (void)animateTransitionForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animation
//{
//    /* temp */
//    UIViewController *fromViewController;
//    UIViewController *toViewController;
//
//    // Create custom transition context
//    RNContextTransitioning *context = [[RNContextTransitioning alloc] initWithFromViewController:fromViewController
//                                                                                toViewController:toViewController];
//
//    [animation animateTransition:context];
//}

@end
