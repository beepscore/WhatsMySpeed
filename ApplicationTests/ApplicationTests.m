//
//  ApplicationTests.m
//  ApplicationTests
//
//  Created by Steve Baker on 11/15/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "ApplicationTests.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController_Extension.h"

@implementation ApplicationTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
    // In application tests the application bundle is loaded before the tests are run.
    // Test setUp doesn't need to instantiate objects from application, just reference them.
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *appDelegate = [application delegate];
    UIWindow *window = [appDelegate window];
    self.vc = (ViewController*)[window rootViewController];
}


- (void)tearDown {
    // Tear-down code here.
    self.vc = nil;
    
    [super tearDown];
}


- (void)testViewControllerIsNotNil {
    STAssertNotNil(self.vc, @"Expected view controller not nil.");
}


- (void)testMapViewIsNotNil {
    STAssertNotNil([self.vc mapView], @"Expected map view not nil.");
}


- (void)testMapShowsUserLocation {
    STAssertTrue([[self.vc mapView] showsUserLocation],
                 @"Expected map view shows user location.");
}


- (void)testMapTrackingModeFollow {
    STAssertTrue( (MKUserTrackingModeFollow == [[self.vc mapView] userTrackingMode]),
                 @"Expected map view tacking mode follow.");
}


- (void)testSpeedLabelOutletConnected {
    STAssertNotNil([self.vc speedLabel],
                 @"Expected speedLabel IBOutlet connected.");
}

@end
