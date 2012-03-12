//
//  RCRAppController.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppController.h"
#import "RCRTopicsViewController.h"

@interface RCRAppController() {
    RCRTopicsViewController *topicsViewController;
    NSView *contentView;
    EDSideBar *sideBar;
}

@end

@implementation RCRAppController

const CGFloat SideBarWidth = 65;
const CGFloat DefaultWindowHeight = 600;
const CGFloat DefaultWindowWidth = 400;

enum {
    RCRSideBarRowTopics        = 0,
    RCRSideBarRowNotification  = 1,
};

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
    [[NSWindow alloc] initWithContentRect:NSMakeRect(400, 300, DefaultWindowWidth + SideBarWidth, DefaultWindowHeight)
                                styleMask:(NSTitledWindowMask |
                                           NSClosableWindowMask |
                                           NSResizableWindowMask |
                                           NSMiniaturizableWindowMask)
                                  backing:NSBackingStoreBuffered
                                    defer:YES];
    [self setWindow:window];

    contentView = [[NSView alloc] initWithFrame:NSMakeRect(SideBarWidth, 0, DefaultWindowWidth, DefaultWindowHeight)];
    [self.window.contentView addSubview:contentView];

    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==65)-[contentView(>=400)]-(==0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView(>=250)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];

    sideBar = [[EDSideBar alloc] initWithFrame:NSMakeRect(0, 0, SideBarWidth, DefaultWindowHeight)];
    sideBar.sidebarDelegate = self;
    sideBar.layoutMode = ECSideBarLayoutTop;
    [self.window.contentView addSubview:sideBar];

    [sideBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sideBar(==65)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sideBar)]];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sideBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sideBar)]];

    topicsViewController = [[RCRTopicsViewController alloc] init];
    NSView *topicsView = topicsViewController.view;
    [contentView addSubview:topicsView];

    [topicsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topicsView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topicsView)]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topicsView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topicsView)]];

    [sideBar addButtonWithTitle:topicsViewController.title image:[NSImage imageNamed:NSImageNameBonjour]];

    [sideBar selectButtonAtRow:RCRSideBarRowTopics];
    [topicsViewController start];
}

- (void)showMainWindow {
    // TODO: need to override DBPrefsWindowController's showWindow
    // another option is to stop using DBPrefsWindowController
    [self showWindow:nil];
}

#pragma mark - EDSlidebarDelegate

- (void)sideBar:(EDSideBar*)tabBar didSelectButton:(NSInteger)index {
}

@end
