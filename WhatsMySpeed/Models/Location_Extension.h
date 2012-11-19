//
//  Location_Extension.h
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/18/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

/**
 \brief Location_Extension.h exposes properties and methods for use by
 Location.m and by unit tests,
 and keeps them from being exposed in header Location.h.
 Reference:
 http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocCategories.html
 */

@interface Location ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, assign) BOOL geocodePending;
@property (nonatomic, strong) NSString *postalCode;

- (void)updatePostalCode:(CLLocation *)newLocation
             withHandler:(CLGeocodeCompletionHandler)completionHandler;
@end

