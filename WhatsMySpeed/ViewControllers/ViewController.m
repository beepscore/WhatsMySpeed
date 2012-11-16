//
//  ViewController.m
//  WhatsMySpeed
//
//  Created by Steve Baker on 11/15/12.
//  Copyright (c) 2012 Beepscore LLC. All rights reserved.
//

#import "ViewController.h"
#import "Location.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.location = [[Location alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.location = nil;
}

@end
