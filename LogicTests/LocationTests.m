//
//  LocationTests.m
//  LocationTests
//
//  Created by Steve Baker on 11/16/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "LocationTests.h"
#import "Location.h"
#import "Location_Extension.h"
#import "OCMock.h"

@implementation LocationTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
    self.location = [[Location alloc] init];
}


- (void)tearDown {
    // Tear-down code here.
    self.location = nil;
    
    [super tearDown];
}


- (void)testInit {
    STAssertNotNil(self.location, @"Expected self.location not nil.");
}


- (void)testThatInitSetsPostalCode {
    STAssertTrue([self.location.postalCode  isEqualToString:@"Unknown"],
                 @"Expected self.location.postalCode 'Unknown' but got %@.", self.location.postalCode);
}


- (void)testThatInitSetsGeocodePendingNo {
    STAssertTrue((NO == self.location.geocodePending),
                 @"Expected self.location.geocodePending NO but got %@.", self.location.geocodePending);
}


- (void)testThatInitSetsGeocoder {
    STAssertNotNil(self.location.geocoder,
                   @"Expected self.location.geocoder not nil.");
    STAssertTrue([self.location.geocoder isKindOfClass:[CLGeocoder class]],
                 @"Expected self.location.geocoder is CLGeocoder.");
}


- (void)testThatInitSetsLocationManager {
    STAssertNotNil(self.location.locationManager,
                   @"Expected self.location.locationManager not nil.");
    
    STAssertTrue([self.location.locationManager  isKindOfClass:[CLLocationManager class]],
                 @"Expected self.location.locationManager is CLLocationManager.");
}


- (void)testThatInitSetsLocationManagerDelegate {
    STAssertNotNil(self.location.locationManager.delegate,
                   @"Expected self.location.locationManager.delegate not nil.");
    
    // Use == to test both variables point to the same memory address, i.e. the same instance.
    // Don't use STAssertEqualObjects, it compares two objects using isEqual:
    STAssertTrue(self.location == self.location.locationManager.delegate,
                 @"Expected self.location equals self.location.locationManager.delegate.");
}


- (void)testThatInitSetsLocationManagerDesiredAccuracy {
    STAssertTrue((kCLLocationAccuracyBestForNavigation == self.location.locationManager.desiredAccuracy),
                 @"Expected desiredAccuracy %g but got %g.",
                 kCLLocationAccuracyBestForNavigation,
                 self.location.locationManager.desiredAccuracy);
}


- (void)testThatInitSetsLocationManagerDistanceFilter {
    STAssertTrue((kCLDistanceFilterNone == self.location.locationManager.distanceFilter),
                 @"Expected distanceFilter %g but got %g.",
                 kCLDistanceFilterNone,
                 self.location.locationManager.distanceFilter);
}


- (void)testStartLocationUpdatesCallsStartUpdatingLocation {
    
    id mockLocationManager = (id)[OCMockObject mockForClass:[CLLocationManager class]];
    
    self.location.locationManager = mockLocationManager;
    
    // Don't throw exception if startUpdatingLocation gets called
    [[mockLocationManager expect] startUpdatingLocation];
    
    [self.location startLocationUpdates];
    
    // verify all stubbed or expected methods were called.
    [mockLocationManager verify];
}


- (void)testUpdatePostalCodeWithPendingNoCallsReverseGeocode {
    
    id mockGeocoder = (id)[OCMockObject mockForClass:[CLGeocoder class]];
    
    // Tell mock object don't raise exception if reverseGeocodeLocation:completionHandler: gets called.
    // don't care about return values
    [[mockGeocoder expect] reverseGeocodeLocation:nil completionHandler:nil];
    
    self.location.geocoder = mockGeocoder;
    
    self.location.geocodePending = NO;
    
    // call method under test,
    // which should in turn call reverseGeocodeLocation:completionHandler:
    [self.location updatePostalCode:nil withHandler:nil];
    
    // Verify expected method reverseGeocodeLocation:completionHandler: was called.
    // If not, OCMock will raise an NSException.
    [mockGeocoder verify];
}


- (void)testUpdatePostalCodeWithPendingYesDoesNotCallReverseGeocode {
    
    id mockGeocoder = (id)[OCMockObject mockForClass:[CLGeocoder class]];
    
    self.location.geocoder = mockGeocoder;
    
    self.location.geocodePending = YES;
    
    // call method under test
    // Note we didn't explicitly "expect" any methods with [mockGeocoder expect].
    // So if updatePostalCode:withHandler: calls any method on location.geocoder, the test will fail.
    [self.location updatePostalCode:nil withHandler:nil];
    
    // Tell mockGeocoder to check that all expected methods were called.
    // With the method as shown in the video, this has no effect.
    [mockGeocoder verify];
}


- (void)testUpdatePostalCodeWithPendingNoSetsPending {
    // Video presenter Lisle notes this test could be written without using a mockGeocoder.
    id mockGeocoder = (id)[OCMockObject mockForClass:[CLGeocoder class]];
    
    // Before calling a method on a mock, we must tell the mock to "expect" that call.
    // If the test calls a method on a mock that wasn't expected or stubbed, the test will fail.
    // Tell mockGeocoder to expect a call to
    // reverseGeocodeLocation:completionHandler: with nil arguments
    // Don't care about return values.
    [[mockGeocoder expect] reverseGeocodeLocation:[OCMArg isNil]
                                completionHandler:[OCMArg isNil]];
    
    self.location.geocoder = mockGeocoder;
    
    self.location.geocodePending = NO;
    
    // call method under test,
    // which should in turn call reverseGeocodeLocation:completionHandler:
    [self.location updatePostalCode:nil withHandler:nil];
    
    // Tell mockGeocoder to verify that all stubbed or expected methods were called.
    // If any verified method wasn't called, the test will fail.
    [mockGeocoder verify];
    
    STAssertTrue(self.location.geocodePending, @"Expected geocodePending");
}


- (void)testCalculateSpeedInMPH {
    
    double kMetersPerMile = 1609.344;
    NSInteger kSecondsPerHour = 60 * 60;
    CLLocationSpeed speedMetersPerSecond = ((55.0 * kMetersPerMile) / kSecondsPerHour);
    
    float actualSpeedMPH = [self.location calculateSpeedInMPH:speedMetersPerSecond];
    float expectedSpeedMPH = 55.0;
    STAssertEqualsWithAccuracy(expectedSpeedMPH,
                               actualSpeedMPH,
                               0.001,
                               @"Expected %f but got %f", expectedSpeedMPH,
                               actualSpeedMPH);
}


- (void)testLocationManagerDidUpdateSetsSpeedMilePerHour {
    
    id mockCLLocation = (id)[OCMockObject mockForClass:[CLLocation class]];
    
    double kMetersPerMile = 1609.344;
    NSInteger kSecondsPerHour = 60 * 60;
    CLLocationSpeed speedMetersPerSecond = ((55.0 * kMetersPerMile) / kSecondsPerHour);
    
    // locationManager:didUpdateLocations: calls
    // calculateSpeedInMPH:[[locations lastObject] speed]
    // So set mockCLLocation to return a stub value for method "speed"
    [[[mockCLLocation stub] andReturnValue:OCMOCK_VALUE(speedMetersPerSecond)] speed];
    
    // locationManager:didUpdateLocations: calls updatePostalCode:withHandler:,
    // but we don't want to test updatePostalCode:withHandler: now.
    // To minimize potential side effects from updatePostalCode:withHandler:,
    // set location.geocodePending YES to exit from
    // updatePostalCode:withHandler: as soon as possible.
    self.location.geocodePending = YES;
    
    // Reduce test dependencies.
    // locationManager:didUpdateLocations: works even if locationManager is nil, so use nil.
    [self.location locationManager:nil
                didUpdateLocations:@[mockCLLocation]];
    
    float expectedSpeedMPH = 55.0;
    STAssertEqualsWithAccuracy(expectedSpeedMPH,
                               self.location.speedMilesPerHour,
                               0.001,
                               @"Expected %f but got %f", expectedSpeedMPH,
                               self.location.speedMilesPerHour);
    
    // verify all stubbed or expected methods were called.
    [mockCLLocation verify];
}


- (void)testLocationManagerDidUpdateUpdatesPostalCode {
    
    id mockCLLocation = (id)[OCMockObject mockForClass:[CLLocation class]];
    
    double kMetersPerMile = 1609.344;
    NSInteger kSecondsPerHour = 60 * 60;
    CLLocationSpeed speedMetersPerSecond = ((55.0 * kMetersPerMile) / kSecondsPerHour);
    
    // locationManager:didUpdateLocations: calls
    // calculateSpeedInMPH:[[locations lastObject] speed]
    // So set mockCLLocation to return a stub value for method "speed"
    [[[mockCLLocation stub] andReturnValue:OCMOCK_VALUE(speedMetersPerSecond)] speed];
    
    // Create a partial mock that will use the original object but override some methods.
    id mockSelfLocation = [OCMockObject partialMockForObject:self.location];
    
    [[mockSelfLocation expect] updatePostalCode:[OCMArg any] withHandler:[OCMArg any]];
    
    // This call uses two mocks, one as the receiver and one as an argument.
    [mockSelfLocation locationManager:nil
                   didUpdateLocations:@[mockCLLocation]];
    
    // verify all stubbed or expected methods were called.
    [mockCLLocation verify];
    [mockSelfLocation verify];
}


- (void)testLocationManagerDidUpdateNotification {
    
    id mockObserver = [OCMockObject observerMock];
    
    [[NSNotificationCenter defaultCenter] addMockObserver:mockObserver
                                                     name:@"LocationChange"
                                                   object:nil];
    
    [[mockObserver expect] notificationWithName:@"LocationChange"
                                         object:[OCMArg any]];
    
    id mockCLLocation = (id)[OCMockObject mockForClass:[CLLocation class]];
    
    double kMetersPerMile = 1609.344;
    NSInteger kSecondsPerHour = 60 * 60;
    CLLocationSpeed speedMetersPerSecond = ((55.0 * kMetersPerMile) / kSecondsPerHour);
    
    // locationManager:didUpdateLocations: calls
    // calculateSpeedInMPH:[[locations lastObject] speed]
    // So set mockCLLocation to return a stub value for method "speed"
    [[[mockCLLocation stub] andReturnValue:OCMOCK_VALUE(speedMetersPerSecond)] speed];
    
    // set location.geocodePending YES to exit from
    // updatePostalCode:withHandler: as soon as possible.
    self.location.geocodePending = YES;
    
    // Reduce test dependencies.
    // locationManager:didUpdateLocations: works even if locationManager is nil, so use nil.
    [self.location locationManager:nil
                didUpdateLocations:@[mockCLLocation]];
    
    [mockObserver verify];
    
    // Must remove observer.
    // iPhone app can support multiple observers.
    // OCMock can't support multiple active mockObservers.
    [[NSNotificationCenter defaultCenter] removeObserver:mockObserver];
}

@end
