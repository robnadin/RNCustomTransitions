//
//  FlipSegue.swift
//  RNCustomTransitionsExample
//
//  Created by Rob Nadin on 21/10/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

import Foundation

class FlipSegue: RNCustomTransitionSegue {
    override func perform() {
        let transition = RNFlipTransition(duration: 0.8, completionBlock: completionBlock)
        
        RNTransitionManager.sharedManager().setTransition(transition, fromViewController: sourceViewController as UIViewController, toViewController: destinationViewController as UIViewController)
        
        // Call super at end of method
        super.perform()
    }
}
