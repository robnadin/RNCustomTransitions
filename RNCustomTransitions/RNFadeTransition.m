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
    CGFloat fromOpacity = 0.0;
    CGFloat toOpacity = 1.0;

    if (self.reverse) {
        tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        [containerView insertSubview:toView belowSubview:fromView];
    } else {
        fromOpacity = 0.5;
        tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        toView.alpha = fromOpacity;
        [containerView insertSubview:toView aboveSubview:fromView];
    }

    [UIView animateWithDuration:self.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         fromView.layer.opacity = fromOpacity;
                         fromView.tintAdjustmentMode = tintAdjustmentMode;
                         toView.alpha = toOpacity;
                     } completion:^(BOOL finished) {
                         completionBlock(finished);
                     }
     ];
}

@end
