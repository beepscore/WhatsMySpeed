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
    
    //self.viewController.mapView = (MKMapView *)mockMapView;
    self.viewController.mapView = mockMapView;
    
    // Don't throw exception if setUserTrackingMode gets called
    [[mockMapView expect] setUserTrackingMode:MKUserTrackingModeFollow];
    
    [self.viewController viewDidLoad];
    
    // verify all stubbed or expected methods were called.
    [mockMapView verify];
}

@end
