//
//  UIImage+RNSnapshot.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 10/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

@import UIKit;

@interface UIImage (RNSnapshot)

+ (UIImage *)imageByCapturingView:(UIView *)view;
+ (UIImage *)imageByCapturingView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates;

+ (UIImage *)blurredImageByCapturingView:(UIView *)view;
+ (UIImage *)blurredImageByCapturingView:(UIView *)view withRadius:(CGFloat)blurRadius;

@end
