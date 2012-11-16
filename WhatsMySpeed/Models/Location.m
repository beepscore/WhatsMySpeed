//
//  Location.m
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/16/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "Location.h"

@implementation Location

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    return self;
}


- (void)startLocationUpdates {
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - Helper methods

- (float)calculateSpeedInMPH:(CLLocationSpeed)speedInMetersPerSecond {
    NSInteger kSecondsPerHour = 60 * 60;
    CLLocationSpeed speedInMetersPerHour = kSecondsPerHour * speedInMetersPerSecond;
    double kMetersPerMile = 1609.344;
    return (speedInMetersPerHour / kMetersPerMile);
}


#pragma mark - LocationManager Delegate method
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    if (!locations
        || (0 == locations.count)) {
        self.speedMilesPerHour = 0.0;
    }
    // if locations contains multiple objects, the lastObject is most recent
    // CLLocation speed is meters per second.
    self.speedMilesPerHour = [self calculateSpeedInMPH:[[locations lastObject] speed]];
}

@end
