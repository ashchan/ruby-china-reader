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
    NSView *contentView;
    EDSideBar *sideBar;
}

- (void)selectViewWithTitle:(NSString *)title;

@end

@implementation RCRAppController

+ (RCRAppController *)sharedAppController{
    static RCRAppController *_sharedAppController = nil;    
	if(!_sharedAppController){
		_sharedAppController = [[self alloc] initWithWindowNibName:@"MainMenu"];
	}
	return _sharedAppController;
}

- (IBAction)showWindow:(id)sender{
    // This forces the resources in the nib to load.
    [self window];

    [super showWindow:sender];
}

- (id)initWithWindow:(NSWindow *)window{
	if((self = [super initWithWindow:nil])){
	}
	return self;
}

- (void)windowDidLoad{
    NSWindow *window = 
    [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 465, 600)
                                styleMask:(NSTitledWindowMask |
                                           NSClosableWindowMask |
                                           NSMiniaturizableWindowMask)
                                  backing:NSBackingStoreBuffered
                                    defer:YES];
    [self setWindow:window];
    contentView = [[NSView alloc] initWithFrame:NSMakeRect(65, 0, 400, 600)];
    [contentView setAutoresizingMask:(NSViewMinYMargin | NSViewWidthSizable)];
    [self.window.contentView addSubview:contentView];

    sideBar = [[EDSideBar alloc] initWithFrame:NSMakeRect(0, 0, 65, 600)];
    sideBar.sidebarDelegate = self;
    [self.window.contentView addSubview:sideBar];

    topicsViewController = [[RCRTopicsViewController alloc] init];
    [contentView addSubview:topicsViewController.view];

    [topicsViewController start];
}

- (void)setupToolbar{
}

- (void)showAbout {
    [self selectViewWithTitle:infoViewController.title];
}

- (void)showOptions {
    [self selectViewWithTitle:optionsViewController.title];
}

- (void)showMainWindow {
    // TODO: need to override DBPrefsWindowController's showWindow
    // another option is to stop using DBPrefsWindowController
    [self showWindow:nil];
}

- (void)selectViewWithTitle:(NSString *)title {
    for (NSToolbarItem *item in self.window.toolbar.items) {
        if ([item.itemIdentifier isEqualToString:title]) {
            //[self toggleActivePreferenceView:item];
            [self.window.toolbar setSelectedItemIdentifier:item.itemIdentifier];
            return;
        }
    }
}

#pragma mark - EDSlidebarDelegate

- (void)sideBar:(EDSideBar*)tabBar didSelectButton:(NSInteger)index {
}

@end
