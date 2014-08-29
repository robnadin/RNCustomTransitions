//
//  RNSlideUpSegue.m
//  RNCustomTransitionsExample
//
//  Created by Robert Nadin on 27/08/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNSlideUpSegue.h"

@implementation RNSlideUpSegue

- (void)perform
{
    RNTransition *transition = [[RNSlideTransition alloc] initWithDuration:0.8
                                                           completionBlock:self.completionBlock];

    [[RNTransitionManager sharedManager] setTransition:transition
                                    fromViewController:self.sourceViewController
                                      toViewController:self.destinationViewController];

    // Call super at end of method
    [super perform];
}

@end
