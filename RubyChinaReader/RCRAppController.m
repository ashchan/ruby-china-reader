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

const CGFloat SideBarWidth = 65;

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
    [[NSWindow alloc] initWithContentRect:NSMakeRect(400, 300, 465, 600)
                                styleMask:(NSTitledWindowMask |
                                           NSClosableWindowMask |
                                           NSResizableWindowMask |
                                           NSMiniaturizableWindowMask)
                                  backing:NSBackingStoreBuffered
                                    defer:YES];
    [self setWindow:window];

    sideBar = [[EDSideBar alloc] initWithFrame:NSMakeRect(0, 0, SideBarWidth, 600)];
    sideBar.sidebarDelegate = self;
    [self.window.contentView addSubview:sideBar];

    [sideBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sideBar(==65)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sideBar)]];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sideBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sideBar)]];

    contentView = [[NSView alloc] initWithFrame:NSMakeRect(SideBarWidth, 0, 400, 600)];
    [self.window.contentView addSubview:contentView];

    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==65)-[contentView(>=400)]-(==0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView(>=250)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];

    topicsViewController = [[RCRTopicsViewController alloc] init];
    NSView *topicsView = topicsViewController.view;
    [contentView addSubview:topicsView];

    [topicsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topicsView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topicsView)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topicsView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topicsView)]];
 
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
