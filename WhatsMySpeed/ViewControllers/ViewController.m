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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleLocationChange:)
     name:@"LocationChange"
     object:nil];
    
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


// viewDidUnload is deprecated in iOS 6.
// For purpose of learning unit test partial mock with "reject", implement viewDidUnload.
// For more info see ViewControllerTests testNotificationHandlerNotCalled.
- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleLocationChange:(NSNotification *)notification {
    Location *locationFromNotification = [notification object];
    self.speedLabel.text = locationFromNotification.speedText;
}

@end
