//
//  RCRAppController.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppController.h"
#import "RCRTopicsViewController.h"
#import "RCRInfoViewController.h"

@interface RCRAppController() {
    RCRTopicsViewController *topicsViewController;
    RCRInfoViewController *infoViewController;
}

@end

@implementation RCRAppController

+ (NSString *)nibName {
    return @"MainMenu";
}

- (void)setupToolbar{
    topicsViewController = [[RCRTopicsViewController alloc] initWithNibName:@"RCRTopicsViewController" bundle:nil];
    [self addView:topicsViewController.view label:topicsViewController.title image:[NSImage imageNamed:NSImageNameBonjour]];

    NSTextView *textView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 300, 400)] autorelease];
    [self addView:textView label:@"Account" image:[NSImage imageNamed:NSImageNameUser]];
    [self addView:textView label:@"Options" image:[NSImage imageNamed:NSImageNameAdvanced]];

    infoViewController = [[RCRInfoViewController alloc] initWithNibName:@"RCRInfoViewController" bundle:nil];
    [self addView:infoViewController.view label:infoViewController.title image:[NSImage imageNamed:NSImageNameInfo]];
}

- (void)dealloc {
    [topicsViewController release];
    [infoViewController release];
    [super dealloc];
}

@end
