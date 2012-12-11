//
//  Location.h
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/16/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

/**
 \brief Location wraps CLLocationManager in order to
 separate concerns and simplify unit testing.
 Unit tests can mock Location.
 
 Based on Location by Ron Lisle, copyright Lynda.com
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 \brief CLLocation speed units are meters per second.
 Name this property with units for clarity.
 */
@property (assign) float speedMilesPerHour;

@property (nonatomic, strong) NSString *speedText;

/** Expose a method to start location updates.
 Unit test can call this method.
 Class could start location updates in init without exposing method,
 but this would make unit testing more difficult.
 */
- (void)startLocationUpdates;

- (float)calculateSpeedInMPH:(CLLocationSpeed)speedInMetersPerSecond;

@end
