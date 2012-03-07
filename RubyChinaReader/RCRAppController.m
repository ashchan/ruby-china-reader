//
//  RCRAppController.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppController.h"
#import "RCRTopicsViewController.h"
#import "RCRAccountViewController.h"
#import "RCROptionsViewController.h"
#import "RCRInfoViewController.h"

@interface RCRAppController() {
    RCRTopicsViewController *topicsViewController;
    RCRAccountViewController *accountViewController;
    RCROptionsViewController *optionsViewController;
    RCRInfoViewController *infoViewController;
}

- (void)selectViewWithTitle:(NSString *)title;

@end

@implementation RCRAppController

+ (NSString *)nibName {
    return @"MainMenu";
}

- (void)setupToolbar{
    topicsViewController = [[RCRTopicsViewController alloc] init];
    [self addView:topicsViewController.view label:topicsViewController.title image:[NSImage imageNamed:NSImageNameBonjour]];
    topicsViewController.topicsTableView.hidden = YES;

    //accountViewController = [[RCRAccountViewController alloc] init];
    //[self addView:accountViewController.view label:accountViewController.title image:[NSImage imageNamed:NSImageNameUser]];
    
    optionsViewController = [[RCROptionsViewController alloc] init];
    [self addView:optionsViewController.view label:optionsViewController.title image:[NSImage imageNamed:NSImageNameAdvanced]];

    infoViewController = [[RCRInfoViewController alloc] init];
    [self addView:infoViewController.view label:infoViewController.title image:[NSImage imageNamed:NSImageNameInfo]];

    [topicsViewController refresh];
}

- (void)showAbout {
    [self selectViewWithTitle:infoViewController.title];
}

- (void)showOptions {
    [self selectViewWithTitle:optionsViewController.title];
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
@end
