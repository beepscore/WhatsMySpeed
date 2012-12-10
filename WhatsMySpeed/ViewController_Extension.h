//
//  ViewController_Extension.h
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/16/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

/**
 \brief ViewController_Extension.h exposes properties and methods for use by
 ViewController.m and by unit tests,
 and keeps them from being exposed in header ViewController.h.
 Reference:
 http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocCategories.html
 */

@interface ViewController ()
// Change IBOutlet memory management from weak to strong for use by unit tests
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *speedLabel;

- (void)beginLocationUpdates:(Location *)aLocation;

@end
