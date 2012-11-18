//
//  LocationTests.m
//  LocationTests
//
//  Created by Steve Baker on 11/16/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "LocationTests.h"
#import "Location.h"

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


- (void)testCalculateSpeedInMPH {
    
    double kMetersPerMile = 1609.344;
    NSInteger kSecondsPerHour = 60 * 60;
    CLLocationSpeed speedMetersPerSecond = ((55.0 * kMetersPerMile) / kSecondsPerHour);
    
    float actualSpeedMPH = [self.location calculateSpeedInMPH:speedMetersPerSecond];
    float expectedSpeedMPH = 55.0;
    STAssertEqualsWithAccuracy(expectedSpeedMPH,
                               actualSpeedMPH,
                               0.001,
                               @"Expected %f but got %f", expectedSpeedMPH, actualSpeedMPH);
}

@end
