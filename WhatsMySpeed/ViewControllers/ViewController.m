//
//  ViewController.m
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/15/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "ViewController.h"
#import "ViewController_Extension.h"
#import "Location.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.location = [[Location alloc] init];
    
    // We want to call
    // [self.location startLocationUpdates]
    // However, if we did it here, it would make unit testing difficult,
    // because we wouldn't have the opportunity to pass a mock object.
    // Instead make a simple method beginLocationUpdates:
    [self beginLocationUpdates:self.location];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
}


// Method has a parameter for location, allowing unit tests to pass in a mock.
// This is called "tell, don't ask".
// Tell method to use argument aLocation, it doesn't ask self for self.location
- (void)beginLocationUpdates:(Location *)aLocation
{
    [aLocation startLocationUpdates];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.location = nil;
}

@end
