//
//  RNFadeTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 08/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNFadeTransition.h"

//static const CGFloat kRNFadeTransitionOpacityFrom   = 0.5f;
//static const CGFloat kRNFadeTransitionOpacityTo     = 1.0f;

@implementation RNFadeTransition

#pragma mark - Required Methods

- (void)animateFromViewController:(UIViewController *)fromViewController
                 toViewController:(UIViewController *)toViewController
                   presentingView:(UIView *)presentingView
                    presentedView:(UIView *)presentedView
                    containerView:(UIView *)containerView
                  completionBlock:(void (^)(BOOL))completionBlock
{
    if (self.reverse) {
        [self dismissViewController:fromViewController
                   toViewController:toViewController
                      presentedView:presentedView
                     presentingView:presentingView
                      containerView:containerView
                    completionBlock:completionBlock];
    } else {
        [self presentViewController:toViewController
                 fromViewController:fromViewController
                      presentedView:presentedView
                     presentingView:presentingView
                      containerView:containerView
                    completionBlock:completionBlock];
    }
    
    /*
    if (self.reverse) {
        presentingView.alpha = kRNFadeTransitionOpacityFrom;
        [containerView addSubview:presentedView];
    } else {
        presentingView.alpha = kRNFadeTransitionOpacityTo;
    }

    [UIView transitionWithView:containerView
                      duration:self.duration
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if (self.reverse) {
                            presentingView.alpha = kRNFadeTransitionOpacityTo;
                            presentingView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                            [presentedView removeFromSuperview];
                            [containerView addSubview:presentingView];
                        } else {
                            presentingView.alpha = kRNFadeTransitionOpacityFrom;
                            presentingView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                            [containerView addSubview:presentedView];
                        }
                    } completion:^(BOOL finished) {
                        completionBlock(finished);
                    }
     ];
     */
}

#pragma mark - Animation Methods

- (void)presentViewController:(UIViewController *)toViewController
           fromViewController:(UIViewController *)fromViewController
                presentedView:(UIView *)presentedView
               presentingView:(UIView *)presentingView
                containerView:(UIView *)containerView
              completionBlock:(void (^)(BOOL))completionBlock
{
    [containerView addSubview:presentedView];
    presentedView.alpha = 0.0;
    
    [UIView transitionWithView:containerView duration:self.duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        presentedView.alpha = 1.0;
        presentingView.alpha = 0.5;
        fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock(finished);
        }
    }];
}

- (void)dismissViewController:(UIViewController *)fromViewController
             toViewController:(UIViewController *)toViewController
                presentedView:(UIView *)presentedView
               presentingView:(UIView *)presentingView
                containerView:(UIView *)containerView
              completionBlock:(void (^)(BOOL))completionBlock
{
    [containerView addSubview:presentingView];
    
    [UIView transitionWithView:containerView duration:self.duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        presentedView.alpha = 1.0;
        presentingView.alpha = 0.0;
        toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock(finished);
        }
    }];
}

@end
