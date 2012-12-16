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


#pragma mark - Notificiation tests

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


- (void)testNotificationHandlerCalled {
    // If NSNotificationCenter wasn't a singleton, we could mock it and
    // have the mock expect a call to addObserver:selector:name:object: when the viewController registers.
    // However, NSNotificationCenter is a singleton and it's difficult to mock it.
    // Instead, mock the view controller using a partial mock.
    // Partial mock is useful to test if an object calls a method on itself.
    
    id mockViewController = [OCMockObject
                             partialMockForObject:self.viewController];
    
    // When the view controller registers for the LocationChange notification,
    // it sets the selector to handleLocationChange:.
    // Expecting and verifying handleLocationChange: is called is an
    // indirect test the viewController registered as an observier, and a
    // direct test the notification response handler calls the desired method.
    [[mockViewController expect] handleLocationChange:[OCMArg any]];
    
    [mockViewController viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationChange"
                                                        object:nil];
    
    // Verify all stubbed or expected methods were called.
    [mockViewController verify];
}


- (void)testNotificationHandlerNotCalled {
    
    id mockViewController = [OCMockObject
                             partialMockForObject:self.viewController];
    
    // If we simply did not "expect" a call to handleLocationChange,
    // and then verified, a full mock could verify handleLocationChange: was not called.
    // However, mockViewController is a partial mock.
    // It would pass a non-expected call through to the base ViewController.
    // So instead use "reject", then verify.
    [[mockViewController reject] handleLocationChange:[OCMArg any]];
    
    // viewController will register for notification
    [mockViewController viewDidLoad];
    
    // viewController will removes itself as oberver.
    // The video shows call [mockViewController viewDidUnload]
    // However viewDidUnload is deprecated, so I implemented removeOberver in dealloc.
    // ARC forbids calling dealloc such as [mockViewController dealloc]
    // http://stackoverflow.com/questions/5816929/how-can-i-write-a-unit-test-that-checks-that-my-properties-are-released-in-dealla
    // So this test is difficult to implement!
    // For learning purposes, in ViewController implement viewDidUnload to call remove observer.
    [mockViewController viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationChange"
                                                        object:nil];
    
    // Verify all stubbed or expected methods were called.
    [mockViewController verify];
}


- (void)testTapGestureHandlerSetsUserTrackingModeFollow {
    
    id mockMapView = [OCMockObject mockForClass:[MKMapView class]];
    self.viewController.mapView = mockMapView;
    
    [[mockMapView expect] setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    [self.viewController mapTapped];
    
    // Verify all stubbed or expected methods were called.
    [mockMapView verify];
}
    
@end
