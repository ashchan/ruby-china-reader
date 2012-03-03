//
//  RCRAppDelegate.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "RCRAppDelegate.h"
#import "RCRAppController.h"

#ifdef DEBUG
    NSString * const API_ENDPOINT = @"http://localhost:3000/";
#else
    NSString * const API_ENDPOINT = @"http://ruby-china.org/";
#endif

@implementation RCRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [RKClient clientWithBaseURL:API_ENDPOINT];
    [[RCRAppController sharedPrefsWindowController] showWindow:nil];
}

@end
