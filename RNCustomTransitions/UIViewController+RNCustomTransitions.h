//
//  UIViewController+RNCustomTransitioning.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

@import UIKit;

@interface UIViewController (RNCustomTransitions)

@property (assign, nonatomic) id <UIViewControllerTransitioningDelegate> transitioningDelegate;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
@property (assign, nonatomic) IBInspectable UIEdgeInsets modalFrameInsets;
@property (assign, nonatomic) IBInspectable CGPoint modalCenterOffset;
#else
@property (assign, nonatomic) UIEdgeInsets modalFrameInsets;
@property (assign, nonatomic) CGPoint modalCenterOffset;
#endif

@end
