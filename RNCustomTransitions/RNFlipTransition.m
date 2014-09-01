//
//  RNFlipTransition.m
//  RNCustomTransitionsExample
//
//  Created by Robert Nadin on 29/08/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNFlipTransition.h"

@implementation RNFlipTransition

#pragma mark - Required Methods

- (void)animateFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView completionBlock:(void (^)(BOOL))completionBlock
{
    UIViewTintAdjustmentMode tintAdjustmentMode;
    UIView *presentingView = (self.reverse) ? toView : fromView;
    UIView *presentedView = (self.reverse) ? fromView : toView;
    presentingView.alpha = self.reverse;

    if (self.reverse) {
        tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        presentingView.alpha = 1.0;
    } else {
        tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }

    [containerView addSubview:fromView];

    [UIView transitionWithView:containerView
                      duration:self.duration
                       options:(self.reverse) ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        presentingView.tintAdjustmentMode = tintAdjustmentMode;
                        [containerView addSubview:toView];
                        [fromView removeFromSuperview];
                    }
                    completion:^(BOOL finished) {
                        completionBlock(finished);
                    }
     ];
}

@end
