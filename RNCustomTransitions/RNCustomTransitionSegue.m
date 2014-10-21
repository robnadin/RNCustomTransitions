//
//  RNCustomTransitionSegue.m
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

#import "RNTransitionManager.h"
#import "RNCustomTransitionSegue.h"

@implementation RNCustomTransitionSegue

- (instancetype)initWithIdentifier:(NSString *)identifier
                            source:(UIViewController *)source
                       destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        _duration = 0.3;
        _unwind = NO;
    }
    return self;
}

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;

    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
    destinationViewController.transitioningDelegate = [RNTransitionManager sharedManager];

    if (self.unwind) {
        [sourceViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [sourceViewController presentViewController:destinationViewController animated:YES completion:nil];
    }
}

@end
