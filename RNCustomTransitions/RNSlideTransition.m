//
//  RNSlideTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 27/08/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNSlideTransition.h"

@implementation RNSlideTransition

@synthesize duration = _duration;

#pragma mark - Init Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.3;
    }
    return self;
}

- (NSTimeInterval)duration
{
    return 0.3;
}

#pragma mark - Required Methods

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
        completionBlock:(void (^)(BOOL))completionBlock
{
    CGFloat opacity;
    UIViewTintAdjustmentMode tintAdjustmentMode;
    UIView *presentingView = (self.reverse) ? toView : fromView;
    UIView *presentedView = (self.reverse) ? fromView : toView;
    CGAffineTransform transform;
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, 1 * CGRectGetHeight(presentingView.frame));

    if (self.reverse) {
        opacity = 1.0;
        tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        transform = translateTransform;
        [containerView insertSubview:toView belowSubview:fromView];
    } else {
        opacity = 0.5;
        tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        presentedView.transform = translateTransform;
        transform = CGAffineTransformIdentity;
        [containerView insertSubview:toView aboveSubview:fromView];
    }

    [UIView animateWithDuration:self.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         presentingView.layer.opacity = opacity;
                         fromView.tintAdjustmentMode = tintAdjustmentMode;
                         presentedView.transform = transform;
                     } completion:^(BOOL finished) {
                         completionBlock(finished);
                     }
     ];
}

@end
