//
//  RNCustomTransitionSegue.h
//  RNCustomTransitions
//
//  Created by Robert Nadin on 07/07/2014.
//  Copyright (c) 2014 TMTI Limited. All rights reserved.
//

@import UIKit;

@interface RNCustomTransitionSegue : UIStoryboardSegue

@property (nonatomic) NSTimeInterval duration;
@property (copy, nonatomic) void (^completionBlock)(BOOL);
@property (assign, nonatomic) BOOL unwind;

#pragma mark - Autocomplete

- (void)setCompletionBlock:(void (^)(BOOL finished))completionBlock;

@end
