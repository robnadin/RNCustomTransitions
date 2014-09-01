//
//  RNTransition.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 08/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+RNCustomTransitions.h"
#import "RNTransitions.h"

@interface RNTransition () <UIGestureRecognizerDelegate>
{
    id<UIViewControllerContextTransitioning> _transitionContext;
}

@property (assign, nonatomic) NSTimeInterval duration;

@end


@implementation RNTransition

#pragma mark - Class Methods

+ (instancetype)transitionWithDuration:(NSTimeInterval)duration completionBlock:(void (^)(BOOL))completionBlock
{
    return [[self.class alloc] initWithDuration:duration completionBlock:completionBlock];
}

#pragma mark - Init Methods

- (instancetype)initWithDuration:(NSTimeInterval)duration completionBlock:(void (^)(BOOL finished))completionBlock
{
    self = [super init];
    if (self) {
        _duration = duration;
        _completionBlock = completionBlock;
    }
    return self;
}

#pragma mark - Public Methods

- (void)animateFromView:(UIView *)fromView
                 toView:(UIView *)toView
        inContainerView:(UIView *)containerView
        completionBlock:(void (^)(BOOL))completionBlock
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Override -animateFromView:toView:inContainerView:executeOnCompletion: in your subclass."
                                 userInfo:nil];
}

#pragma mark - Required Methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;

    UIModalPresentationStyle presentationStyle = [transitionContext presentationStyle];

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    [containerView addGestureRecognizer:tapGesture];

    UIEdgeInsets insets = toViewController.modalFrameInsets;
    CGPoint offset = toViewController.modalCenterOffset;
    BOOL isFrameEqual = CGRectEqualToRect(fromViewController.view.frame, toViewController.view.frame);
    UIViewController *presentingViewController = toViewController.presentingViewController;
    if (presentingViewController) {
        isFrameEqual = CGRectEqualToRect(presentingViewController.view.frame, toViewController.view.frame);
    }
    BOOL isFrameInset = !UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero);
    BOOL isFrameOffset = !CGPointEqualToPoint(offset, CGPointZero);

    if (!isFrameEqual) {
        toViewController.view.autoresizingMask = UIViewAutoresizingNone;
        toViewController.view.center = containerView.center;

        if (isFrameInset) {
            toViewController.view.frame = UIEdgeInsetsInsetRect(fromViewController.view.frame, insets);
        }

        if (isFrameOffset) {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
            toViewController.view.center = CGPointApplyAffineTransform(containerView.center, transform);;
        }
    }

    if (presentingViewController) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad: Determine frame size of toViewController's view based on presentation style
            switch (presentationStyle) {
                case UIModalPresentationPageSheet:
                {
                    BOOL isLandscape = UIInterfaceOrientationIsLandscape(fromViewController.interfaceOrientation);
                    if (isLandscape) {
                        // !!!: Container view frame is always sized for portrait orientation
                        CGPoint origin = toViewController.view.frame.origin;
                        CGFloat width = CGRectGetWidth(toViewController.view.frame);
                        if (origin.x < 0 && width == CGRectGetHeight(containerView.frame)) {
                            toViewController.view.frame = CGRectMake(0, origin.y, CGRectGetWidth(containerView.frame), CGRectGetHeight(toViewController.view.frame));
                        }
                    }
                    if (CGRectGetWidth(toViewController.view.frame) == CGRectGetWidth(containerView.frame)) {
                        toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    }
                    break;
                }

                default:
                    NSLog(@"Modal presentation style not implemented!");
            }
        }
    }

    RNTransition *transition;

    if (presentationStyle != UIModalPresentationCustom) {
        switch (presentationStyle) {
            case UIModalPresentationFullScreen:
                break;

            default:
                break;
        }

        UIViewController *viewController;
        if (fromViewController.isBeingDismissed) {
            viewController = fromViewController;
        }

        if (viewController.isBeingPresented || viewController.isBeingDismissed) {
            transition.reverse = viewController.isBeingDismissed;
        }
    }

    // Enable/disable user interaction for the source view controller
    UIViewController *sourceViewController = (self.reverse) ? toViewController : fromViewController;
    sourceViewController.view.userInteractionEnabled = self.reverse;

    [transition?:self animateFromView:fromViewController.view
                               toView:toViewController.view
                      inContainerView:containerView
                      completionBlock:^(BOOL finished) {
                          BOOL wasCancelled = [transitionContext transitionWasCancelled];
                          if (wasCancelled) {
                              [toViewController.view removeFromSuperview];
                          }
                          // Just in case...
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [transitionContext completeTransition:!wasCancelled];
                          });
                      }
     ];
}

#pragma mark - Optional Methods

- (void)animationEnded:(BOOL)transitionCompleted
{
    if (self.completionBlock) {
        self.completionBlock(transitionCompleted);
    }
}

#pragma mark - UITapGestureRecognizer Methods

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    UIViewController *toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGPoint point = [sender locationInView:nil];

    // Dismiss the presented view if the location of the gesture is within its bounds
    if (!CGRectContainsPoint(toViewController.view.frame, point)) {
        [toViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIViewController *toViewController = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGPoint point = [gestureRecognizer locationInView:nil];
    return !toViewController.presentedViewController && !CGRectContainsPoint(toViewController.view.frame, point);
}

@end
