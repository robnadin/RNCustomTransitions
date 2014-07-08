//
//  UIImage+RNSnapshot.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 10/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

@import Accelerate;

#import "UIImage+RNSnapshot.h"

@implementation UIImage (RNSnapshot)

#pragma mark - Class Methods

+ (UIImage *)imageByCapturingView:(UIView *)view
{
    return [self imageByCapturingView:view afterScreenUpdates:YES];
}

+ (UIImage *)imageByCapturingView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);

    BOOL success = [self didTakeScreenshotInView:view afterScreenUpdates:afterUpdates];

    UIImage *image;
    if (success) {
        image = UIGraphicsGetImageFromCurrentImageContext();
    }

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)blurredImageByCapturingView:(UIView *)view
{
    return [self blurredImageByCapturingView:view withRadius:10];
}

+ (UIImage *)blurredImageByCapturingView:(UIView *)view
                              withRadius:(CGFloat)blurRadius
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);

    BOOL success = [self didTakeScreenshotInView:view afterScreenUpdates:YES];

    UIImage *image;

    if (success) {
        BOOL hasBlur = blurRadius > FLT_EPSILON;

        if (hasBlur) {
            CGContextRef effectInContext = UIGraphicsGetCurrentContext();
            vImage_Buffer effectInBuffer;
            effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
            effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
            effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
            effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

            UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);

            CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
            vImage_Buffer effectOutBuffer;
            effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
            effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
            effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
            effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

            if (hasBlur) {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                CGFloat inputRadius = blurRadius * [UIScreen mainScreen].scale;
                NSUInteger radius = floor(inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5);

                if (radius % 2 != 1) {
                    radius += 1; // force radius to be odd so that the three box-blur methodology works.
                }

                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            }

            image = UIGraphicsGetImageFromCurrentImageContext();

            UIGraphicsEndImageContext();
        }
    }

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Helper Methods

+ (BOOL)didTakeScreenshotInView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates
{
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:afterUpdates];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context) {
            [view.layer renderInContext:context];
        }
        return context ? YES : NO;
    }
}

@end
