//
//  RNTransitionManager.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 09/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

@import Foundation;

#import "RNTransition.h"

@interface RNTransitionManager : NSObject <UIViewControllerTransitioningDelegate>

//@property (copy, nonatomic, readonly) NSMutableDictionary *animations;

+ (instancetype)sharedManager;

- (void)setTransition:(RNTransition *)transition fromViewController:(UIViewController *)fromViewController;
- (void)setTransition:(RNTransition *)transition fromViewController:(UIViewController *)fromViewController
     toViewController:(UIViewController *)toViewController;

@end
