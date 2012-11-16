//
//  ApplicationTests.m
//  ApplicationTests
//
//  Created by Steve Baker on 11/15/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "ApplicationTests.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation ApplicationTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
    // In application tests the application bundle is loaded before the tests are run.
    // Test setUp doesn't need to instantiate objects from application, just reference them.
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *appDelegate = [application delegate];
    UIWindow *window = [appDelegate window];
    self.vc = (ViewController*)[window rootViewController];
}


- (void)tearDown {
    // Tear-down code here.
    self.vc = nil;
    
    [super tearDown];
}


- (void)testViewControllerIsNotNil {
    STAssertNotNil(self.vc, @"Expected view controller not nil.");
}

@end
