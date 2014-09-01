//
//  RNSlideTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 27/08/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNSlideTransition.h"

@implementation RNSlideTransition

#pragma mark - Init Methods

- (instancetype)initWithDuration:(NSTimeInterval)duration completionBlock:(void (^)(BOOL))completionBlock
{
    self = [super initWithDuration:duration completionBlock:completionBlock];
    if (self) {
        _springDampingRatio = 0.75;
        _springVelocity = 0.1;
    }
    return self;
}

#pragma mark - Required Methods

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
        completionBlock:(void (^)(BOOL))completionBlock
{
    CGAffineTransform endTransform;
    UIViewTintAdjustmentMode tintAdjustmentMode;
    UIView *presentingView = (self.reverse) ? toView : fromView;
    UIView *presentedView = (self.reverse) ? fromView : toView;

    CGRect containerFrame = containerView.frame;
    CGRect presentedFrame = presentedView.frame;

    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        // Transpose the frames on iOS 7 if in landscape orientation
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            containerFrame = [self transposedRect:containerFrame];
            presentedFrame = [self transposedRect:presentedFrame];
        }
    }

    CGFloat slideHeight = MAX(CGRectGetHeight(containerFrame), CGRectGetHeight(presentedFrame));
    CGAffineTransform translateTransform = CGAffineTransformTranslate(presentedView.transform, 0, slideHeight);

    if (self.reverse) {
        endTransform = translateTransform;
        tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        [containerView addSubview:presentingView];
    } else {
        endTransform = presentedView.transform;
        tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        presentedView.transform = translateTransform;
    }

    [containerView addSubview:presentedView];

    [UIView animateWithDuration:self.duration
                          delay:0
         usingSpringWithDamping:self.springDampingRatio
          initialSpringVelocity:self.springVelocity
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         presentingView.alpha = (self.reverse) ? 1.0 : 0.5;
                         presentingView.tintAdjustmentMode = tintAdjustmentMode;
                         presentedView.transform = endTransform;
                     } completion:^(BOOL finished) {
                         completionBlock(finished);
                     }
     ];
}

#pragma mark - Helper Methods

- (CGRect)transposedRect:(CGRect)rect
{
    return (CGRect){rect.origin, CGSizeMake(rect.size.height, rect.size.width)};
}

@end
