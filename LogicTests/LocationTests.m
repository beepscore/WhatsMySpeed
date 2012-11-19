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


- (void)testThatInitSetsLocationManager {
    STAssertNotNil(self.location.locationManager,
                   @"Expected self.location.locationManager not nil.");
    STAssertTrue([self.location.locationManager  isKindOfClass:[CLLocationManager class]],
                   @"Expected self.location.locationManager is CLLocationManager.");
}


- (void)testUpdatePostalCodeWithPendingNoCallsReverseGeocode {

    id mockGeocoder = (id)[OCMockObject mockForClass:[CLGeocoder class]];
    
    // we just want to test thatreverseGeocodeLocation:completionHandler gets called
    // don't care about return values
    [[mockGeocoder expect] reverseGeocodeLocation:nil completionHandler:nil];
    
    self.location.geocoder = mockGeocoder;
    
    self.location.geocodePending = NO;
    
    // call method under test
    [self.location updatePostalCode:nil withHandler:nil];
    
    // verify the expected method was called
    [mockGeocoder verify];
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
    // So mockCLLocation must be able to return a stub value for method "speed"
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
}

@end
