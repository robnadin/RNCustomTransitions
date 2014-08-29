//
//  RNFadeTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 08/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNFadeTransition.h"

@implementation RNFadeTransition

#pragma mark - Required Methods

- (void)animateFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView completionBlock:(void (^)(BOOL))completionBlock
{
    UIViewTintAdjustmentMode tintAdjustmentMode;
    UIView *presentingView = (self.reverse) ? toView : fromView;
    UIView *presentedView = (self.reverse) ? fromView : toView;
    presentedView.alpha = self.reverse;

    if (self.reverse) {
        tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    } else {
        tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    }

    [containerView addSubview:presentedView];

    [UIView animateWithDuration:self.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         presentingView.alpha = (self.reverse) ? 1.0 : 0.5;
                         presentingView.tintAdjustmentMode = tintAdjustmentMode;
                         presentedView.alpha = !self.reverse;
                     } completion:^(BOOL finished) {
                         completionBlock(finished);
                     }
     ];
}

@end
