//
//  ViewControllerTests.m
//  WhatsMySpeed
//
//  Created by Steve Baker on 12/9/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ViewController.h"
#import "ViewController_Extension.h"
#import "OCMock.h"
#import "Location.h"

@interface ViewControllerTests : SenTestCase
@property (nonatomic, strong) ViewController *viewController;
@end


@implementation ViewControllerTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
    self.viewController = [[ViewController alloc] init];
}


- (void)tearDown {
    // Tear-down code here.
    self.viewController = nil;
    
    [super tearDown];
}


- (void)testViewControllerNotNil {
    STAssertNotNil(self.viewController,
                   @"Expected viewController not nil");
}


- (void)testViewDidLoadSetsUserTrackingMode {
    id mockMapView = [OCMockObject mockForClass:[MKMapView class]];
    
    self.viewController.mapView = mockMapView;
    
    // Don't throw exception if setUserTrackingMode gets called
    [[mockMapView expect] setUserTrackingMode:MKUserTrackingModeFollow];
    
    [self.viewController viewDidLoad];
    
    // verify all stubbed or expected methods were called.
    [mockMapView verify];
}


- (void)testViewDidLoadSetsLocation {
    [self.viewController viewDidLoad];
    STAssertNotNil(self.viewController.location,
                   @"Expected location not nil");
}


- (void)testViewDidLoadCallsBeginLocationUpdates {
    
    // use a partial mock to test if the viewController calls a method on itself
    id mockViewController = [OCMockObject
                             partialMockForObject:self.viewController];
    
    // Don't throw exception if beginLocationUpdates gets called.
    // Xcode complained about argument mockViewController.location, so use any.
    // [[mockViewController expect] beginLocationUpdates:mockViewController.location];
    [[mockViewController expect] beginLocationUpdates:[OCMArg any]];
    
    [mockViewController viewDidLoad];
    
    // use the partial mock to verify all stubbed or expected methods were called.
    [mockViewController verify];
}


- (void)testBeginLocationUpdatesCallsStartLocationUpdates {
    id mockLocation = [OCMockObject mockForClass:[Location class]];
    
    // Don't throw exception if startLocationUpdates gets called
    [[mockLocation expect] startLocationUpdates];
    
    [self.viewController beginLocationUpdates:mockLocation];
    
    // verify all stubbed or expected methods were called.
    [mockLocation verify];
}


- (void)testLocationChangeNotificationUpdatesSpeed {
    
    id mockLocation = [OCMockObject mockForClass:[Location class]];
    
    [(Location *)[[mockLocation stub] andReturn:@"55 MPH"] speedText];
    
    id notificationMock = [OCMockObject mockForClass:[NSNotification class]];
    
    // Tell notificationMock to stub NSNotification method "object" and return the mockLocation
    [[[notificationMock stub] andReturn:(Location *)mockLocation] object];
    
    id labelMock = [OCMockObject mockForClass:[UILabel class]];
    [[labelMock expect] setText:@"55 MPH"];
    
    [self.viewController setSpeedLabel:labelMock];
    
    [self.viewController handleLocationChange:(NSNotification *)notificationMock];
    
    [labelMock verify];
}


// It's difficult to mock or partially mock singleton NSNotificationCenter
// Instead, mock view controller
- (void)testThatNotificationHandlerCalled {
    
    // use a partial mock to test if the viewController calls a method on itself
    id mockViewController = [OCMockObject
                             partialMockForObject:self.viewController];
    
    [[mockViewController expect] handleLocationChange:[OCMArg any]];
    
    [mockViewController viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationChange"
                                                        object:nil];
    
    // use the partial mock to verify all stubbed or expected methods were called.
    [mockViewController verify];
}

@end
