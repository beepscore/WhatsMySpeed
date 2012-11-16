//
//  ViewController.h
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/15/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class Location;

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) Location *location;

@end
