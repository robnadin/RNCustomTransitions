//
//  RNZoomTransition.h
//  RNCustomTransitionsExample
//
//  Created by Robert Nadin on 28/08/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNTransition.h"

@protocol RNZoomTransitionDelegate <NSObject>

- (CGPoint)zoomOrigin;

@end


@interface RNZoomTransition : RNTransition

@property (nonatomic) id<RNZoomTransitionDelegate> zoomTransitionDelegate;
@property (nonatomic) CGFloat springDampingRatio;
@property (nonatomic) CGFloat springVelocity;

@end
