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

- (void)animateFromViewController:(UIViewController *)fromViewController
                 toViewController:(UIViewController *)toViewController
                   presentingView:(UIView *)presentingView
                    presentedView:(UIView *)presentedView
                    containerView:(UIView *)containerView
                  completionBlock:(void (^)(BOOL))completionBlock
{
    if (!self.reverse) {
        [self presentViewController:toViewController
                 fromViewController:fromViewController
                      presentedView:presentedView
                     presentingView:presentingView
                      containerView:containerView
                    completionBlock:completionBlock];
    } else {
        [self dismissViewController:fromViewController
                   toViewController:toViewController
                      presentedView:presentingView
                     presentingView:presentedView
                      containerView:containerView
                    completionBlock:completionBlock];
    }
    
    /*
    CGAffineTransform endTransform;
    UIViewTintAdjustmentMode tintAdjustmentMode;

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

    if (!presentedView) {
        presentedView = fromViewController.view; //temp// todo: move to base class
    }
    
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
    
    CGRect containerFrame = containerView.frame;
    CGRect presentedFrame = presentedView.frame;
    
    CGFloat slideHeight = MAX(CGRectGetHeight(containerFrame), CGRectGetHeight(presentedFrame));
    CGAffineTransform translateTransform = CGAffineTransformTranslate(presentedView.transform, 0, slideHeight);
    
    CGAffineTransform endTransform = presentedView.transform;
    
    presentedView.transform = translateTransform;
    
    [UIView animateWithDuration:self.duration
                          delay:0
         usingSpringWithDamping:self.springDampingRatio
          initialSpringVelocity:self.springVelocity
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         presentingView.alpha = 0.5;
                         presentedView.transform = endTransform;
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
    [containerView addSubview:presentedView];
    
    CGRect containerFrame = containerView.frame;
    CGRect presentedFrame = presentedView.frame;
    
    CGFloat slideHeight = MAX(CGRectGetHeight(containerFrame), CGRectGetHeight(presentedFrame));
    CGAffineTransform translateTransform = CGAffineTransformTranslate(presentedView.transform, 0, slideHeight);
    CGAffineTransform endTransform = translateTransform;
    
    [UIView animateWithDuration:self.duration
                          delay:0
         usingSpringWithDamping:self.springDampingRatio
          initialSpringVelocity:self.springVelocity
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            presentingView.alpha = 1.0;
                            presentedView.transform = endTransform;
                            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                        } completion:^(BOOL finished) {
                            if (completionBlock) {
                                completionBlock(finished);
                            }
                        }];
}

#pragma mark - Helper Methods

- (CGRect)transposedRect:(CGRect)rect
{
    return (CGRect){rect.origin, CGSizeMake(rect.size.height, rect.size.width)};
}

@end
