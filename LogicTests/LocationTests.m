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

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.location = [[Location alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    self.location = nil;
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in LogicTests");
}

@end
