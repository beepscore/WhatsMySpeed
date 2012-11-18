//
//  LocationGHTests.m
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/18/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@interface LocationGHTests : GHTestCase { }
@end

@implementation LocationGHTests

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}


- (void)testObjects {
    // NSString *a = @"foo";
    NSString *a = @"a string";
    GHTestLog(@"I can log to the GHUnit test console: %@", a);
    
    // Assert a is not nil, with no custom error description
    GHAssertNotNil(a, nil);
    
    // Assert equal objects, add custom error description
    // NSString *b = @"bar";
    NSString *b = @"a string";
    GHAssertEqualObjects(a, b, @"A custom error message. a should be equal to: %@.", b);
}


- (void)testEqualStrings {
    // If last argument is nil, GHAssert provides a useful message showing expected and actual values.
    // STAssert's message for nil isn't as nice.
    GHAssertEqualStrings(@"abc", @"ABC", nil);
}

@end
