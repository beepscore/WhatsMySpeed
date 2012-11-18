//
//  WeatherAPITests.m
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/18/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//
// Reference:
// ExampleAsyncTest
// http://gabriel.github.com/gh-unit/docs/appledoc_include/guide_testing.html

#import <GHUnitIOS/GHUnit.h>

@interface WeatherAPITests : GHAsyncTestCase
// store response so we can test it
@property (nonatomic, strong) NSString *APIResponse;
@end


@implementation WeatherAPITests

- (void)testWeatherAPI {
    
    // Call prepare to setup the asynchronous action.
    // This helps in cases where the action is synchronous and the
    // action occurs before the wait is actually called.
    [self prepare];
    
    NSURL *weatherURL = [NSURL URLWithString:@"http://www.google.com/ig/api?weather=98053"];
    NSURLRequest *request = [NSURLRequest requestWithURL:weatherURL];
    
    // FIXME: Xcode warns variable connection unused.
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:YES];
    
    // Wait until notify called for timeout (seconds);
    // If notify is not called with kGHUnitWaitStatusSuccess then
    // we will throw an error.
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
}

# pragma mark - Event handlers

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Notify of success, specifying the method where wait is called.
    // This prevents stray notifies from affecting other tests.
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testWeatherAPI)];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Notify of connection failure
    [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testURLConnection)];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    self.APIResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    GHTestLog(@"%@", self.APIResponse);
}

@end
