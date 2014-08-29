//
//  RNZoomSegue.m
//  RNCustomTransitionsExample
//
//  Created by Robert Nadin on 28/08/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNZoomSegue.h"

@implementation RNZoomSegue

- (void)perform
{
    RNTransition *transition = [[RNZoomTransition alloc] initWithDuration:0.8
                                                          completionBlock:self.completionBlock];
    [(RNZoomTransition *)transition setZoomTransitionDelegate:self.delegate];

    [[RNTransitionManager sharedManager] setTransition:transition
                                    fromViewController:self.sourceViewController
                                      toViewController:self.destinationViewController];

    // Call super at end of method
    [super perform];
}

@end
