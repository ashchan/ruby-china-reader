//
//  RCRAppDelegate.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppDelegate.h"
#import "RCRAppController.h"

@implementation RCRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[RCRAppController sharedPrefsWindowController] showWindow:nil];
}

@end
