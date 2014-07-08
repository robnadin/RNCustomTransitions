//
//  RNViewController.m
//  RNCustomTransitionsExample
//
//  Created by Robert Nadin on 08/07/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNFadeTransition.h"

#import "RNViewController.h"

@interface RNViewController ()

@end


@implementation RNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

- (IBAction)unwindToRoot:(UIStoryboardSegue *)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
