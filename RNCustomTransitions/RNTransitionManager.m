//
//  RNTransitionManager.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 09/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNTransition.h"
#import "RNTransitionManager.h"

@interface RNTransitionModel : NSObject <NSCopying>

@property (nonatomic) Class fromViewControllerClass;
@property (nonatomic) Class toViewControllerClass;

@end


@interface RNTransitionManager ()

@property (nonatomic) NSMutableDictionary *animationControllers;

@end


@implementation RNTransitionManager

+ (instancetype)sharedManager
{
    static id _sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self new];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animationControllers = @{}.mutableCopy;
    }
    return self;
}

#pragma mark - Public Methods

- (void)setTransition:(RNTransition *)transition fromViewController:(UIViewController *)fromViewController
{
    [self setTransition:transition fromViewController:fromViewController toViewController:nil];
}

- (void)setTransition:(RNTransition *)transition fromViewController:(UIViewController *)fromViewController
     toViewController:(UIViewController *)toViewController
{
    RNTransitionModel *keyValue = [[RNTransitionModel alloc] init];
    keyValue.fromViewControllerClass = fromViewController.class;
    keyValue.toViewControllerClass = toViewController.class;

    [self.animationControllers setObject:transition forKey:keyValue];
}

- (RNTransition *)transitionForFromViewController:(UIViewController *)fromViewController
{
    return [self transitionForFromViewController:fromViewController toViewController:nil];
}

- (RNTransition *)transitionForFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    RNTransitionModel *keyValue = [[RNTransitionModel alloc] init];
    keyValue.fromViewControllerClass = fromViewController.class;
    keyValue.toViewControllerClass = toViewController.class;

    __block RNTransition *animationController = [self.animationControllers objectForKey:keyValue];

    if (!animationController) {
        if (fromViewController.isBeingDismissed) {
            UIViewController *presentingViewController = fromViewController.presentingViewController;
            keyValue.fromViewControllerClass = presentingViewController.class;
            animationController = [self.animationControllers objectForKey:keyValue];

            if (!animationController) {
                [presentingViewController.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *childViewController, NSUInteger idx, BOOL *stop) {
                    keyValue.fromViewControllerClass = childViewController.class;
                    animationController = [self.animationControllers objectForKey:keyValue];
                    *stop = (animationController != nil);
                }];
            }
        }
    }

    return animationController;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    RNTransitionModel *keyValue = [[RNTransitionModel alloc] init];
    keyValue.fromViewControllerClass = source.class;
    keyValue.toViewControllerClass = presented.class;

    RNTransition *animationController = [self.animationControllers objectForKey:keyValue];

    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    RNTransitionModel *keyValue = [[RNTransitionModel alloc] init];
    keyValue.fromViewControllerClass = nil;
    keyValue.toViewControllerClass = dismissed.class;

    __block RNTransition *animationController = [self.animationControllers objectForKey:keyValue];

    if (!animationController) {
        UIViewController *presentingViewController = dismissed.presentingViewController;
        keyValue.fromViewControllerClass = presentingViewController.class;
        animationController = [self.animationControllers objectForKey:keyValue];

        if (!animationController) {
            [presentingViewController.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *childViewController, NSUInteger idx, BOOL *stop) {
                keyValue.fromViewControllerClass = childViewController.class;
                animationController = [self.animationControllers objectForKey:keyValue];
                *stop = (animationController != nil);
            }];
        }
    }

    if (animationController) {
        animationController.reverse = YES;
    }

    return animationController;
}

@end


@implementation RNTransitionModel

- (instancetype)copyWithZone:(NSZone *)zone
{
    RNTransitionModel *copiedObject = [[self.class allocWithZone:zone] init];
//    copiedObject.transitionAction = self.transitionAction;
    copiedObject.fromViewControllerClass = self.fromViewControllerClass;
    copiedObject.toViewControllerClass = self.toViewControllerClass;

    return copiedObject;
}

- (NSUInteger)hash
{
    // If two objects are equal, they must have the same hash value.
    return
//    self.transitionAction ^
    self.fromViewControllerClass.hash ^
    self.toViewControllerClass.hash;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:RNTransitionModel.class]) {
        return NO;
    }

    RNTransitionModel *otherObject = (RNTransitionModel *)object;

    return
//    (otherObject.transitionAction & self.transitionAction) &&
    (otherObject.fromViewControllerClass == self.fromViewControllerClass) &&
    (otherObject.toViewControllerClass == self.toViewControllerClass);
}

@end
