//
//  RCRPrefsController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/12/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRPrefsController.h"
#import "RCRAccountViewController.h"
#import "RCROptionsViewController.h"
#import "RCRInfoViewController.h"

@interface RCRPrefsController () {
    RCRAccountViewController *accountViewController;
    RCROptionsViewController *optionsViewController;
    RCRInfoViewController *infoViewController;
}
@end

@implementation RCRPrefsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setStyleMask:self.window.styleMask & ~NSMiniaturizableWindowMask];
}

- (void)setupToolbar {
    optionsViewController = [[RCROptionsViewController alloc] init];
    [self addView:optionsViewController.view label:optionsViewController.title image:[optionsViewController image]];
    
    accountViewController = [[RCRAccountViewController alloc] init];
    [self addView:accountViewController.view label:accountViewController.title image:[accountViewController image]];

    infoViewController = [[RCRInfoViewController alloc] init];
    [self addView:infoViewController.view label:infoViewController.title image:[infoViewController image]];
}

- (void)selectViewWithTitle:(NSString *)title {
    for (NSToolbarItem *item in self.window.toolbar.items) {
        if ([item.itemIdentifier isEqualToString:title]) {
            [self toggleActivePreferenceView:item];
            [self.window.toolbar setSelectedItemIdentifier:item.itemIdentifier];
            return;
        }
    }
}

- (void)showPreferences {
    if (![self.window isVisible]) {
        [self showWindow:nil];
    }
    [self.window makeKeyAndOrderFront:nil];
}

- (void)showAbout {
    if (![self.window isVisible]) {
        [self showWindow:nil];
    }
    [self.window makeKeyAndOrderFront:nil];
    [self selectViewWithTitle:infoViewController.title];
}

- (void)showAccount {
    if (![self.window isVisible]) {
        [self showWindow:nil];
    }
    [self.window makeKeyAndOrderFront:nil];
    [self selectViewWithTitle:accountViewController.title];
}

@end
