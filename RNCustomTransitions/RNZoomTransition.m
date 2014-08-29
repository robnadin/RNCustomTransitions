//
//  RNZoomTransition.m
//  RNCustomTransitionsExample
//
//  Created by Robert Nadin on 28/08/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNZoomTransition.h"

@implementation RNZoomTransition

#pragma mark - Required Methods

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
        completionBlock:(void (^)(BOOL))completionBlock
{
    CGRect endFrame;
    UIViewTintAdjustmentMode tintAdjustmentMode;
    UIView *presentingView = (self.reverse) ? toView : fromView;
    UIView *presentedView = (self.reverse) ? fromView : toView;
    UIView *resizableSnapshotView = [presentedView resizableSnapshotViewFromRect:presentedView.bounds
                                                              afterScreenUpdates:YES
                                                                   withCapInsets:UIEdgeInsetsZero];
    resizableSnapshotView.alpha = self.reverse;
    resizableSnapshotView.transform = presentedView.transform;

    CGPoint origin;
    if ([self.zoomTransitionDelegate respondsToSelector:@selector(zoomOrigin)]) {
        origin = [containerView convertPoint:[self.zoomTransitionDelegate zoomOrigin]
                                    fromView:presentingView];
    } else {
        origin = presentingView.center;
    }

    if (self.reverse) {
        endFrame = (CGRect){origin, CGSizeZero};
        tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        resizableSnapshotView.center = presentedView.center;
        [presentedView removeFromSuperview];
    } else {
        endFrame = toView.frame;
        tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        resizableSnapshotView.frame = (CGRect){origin, CGSizeZero};
    }

    [containerView addSubview:resizableSnapshotView];

    [UIView animateWithDuration:self.duration
                          delay:0
         usingSpringWithDamping:0.75
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         presentingView.alpha = (self.reverse) ? 1.0 : 0.5;
                         presentingView.tintAdjustmentMode = tintAdjustmentMode;
                         resizableSnapshotView.alpha = !self.reverse;
                         resizableSnapshotView.frame = endFrame;
                     } completion:^(BOOL finished) {
                         if (!self.reverse) {
                             [containerView addSubview:presentedView];
                         }
                         [resizableSnapshotView removeFromSuperview];
                         completionBlock(finished);
                     }
     ];
}

@end
