//
//  Location.m
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/16/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "Location.h"

@interface Location ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, assign) BOOL geocodePending;
@property (nonatomic, strong) NSString *postalCode;
@end


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
    
    _geocoder = [[CLGeocoder alloc] init];
    
    return self;
}


- (void)startLocationUpdates {
    [self.locationManager startUpdatingLocation];
}


#pragma mark - Helper methods

- (void)updatePostalCode:(CLLocation *)newLocation
             withHandler:(CLGeocodeCompletionHandler)completionHandler {
    
    if (YES == self.geocodePending) {
        return;
    }
    self.geocodePending = YES;
    
    [self.geocoder reverseGeocodeLocation:newLocation
                        completionHandler:completionHandler];
}


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

    } else {
        // we have at least one location
        // if locations contains multiple objects, the lastObject is most recent.
        
        [self updatePostalCode:[locations lastObject]
                   withHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark *placemark = placemarks[0];
                       [self setPostalCode:[placemark postalCode]];
                       self.geocodePending = NO;
                   }];
        
        // CLLocation speed is meters per second.
        self.speedMilesPerHour = [self calculateSpeedInMPH:[[locations lastObject] speed]];
    }
}

@end
