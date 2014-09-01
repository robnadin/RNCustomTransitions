//
//  RNFadeTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 08/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNFadeTransition.h"

static const CGFloat kRNFadeTransitionOpacityFrom   = 0.5f;
static const CGFloat kRNFadeTransitionOpacityTo     = 1.0f;

@implementation RNFadeTransition

#pragma mark - Required Methods

- (void)animateFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView completionBlock:(void (^)(BOOL))completionBlock
{
    UIView *presentingView = (self.reverse) ? toView : fromView;
    UIView *presentedView = (self.reverse) ? fromView : toView;

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
}

@end
