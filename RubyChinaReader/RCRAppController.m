//
//  RCRAppController.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppController.h"
#import "RCRTopicsViewController.h"
#import "RCRSettingsManager.h"
#import "RCRPrefsController.h"

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
    window.delegate = self;
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

    NSButton *newTopicButton = [[NSButton alloc] init];
    newTopicButton.bezelStyle = NSThickSquareBezelStyle;
    newTopicButton.image = [NSImage imageNamed:NSImageNameAddTemplate];
    newTopicButton.target = self;
    newTopicButton.action = @selector(newTopic);
    [self.window.contentView addSubview:newTopicButton];

    [newTopicButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[newTopicButton(==20)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(newTopicButton)]];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[newTopicButton(==20)]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(newTopicButton)]];

    NSButton *refreshButton = [[NSButton alloc] init];
    [refreshButton bind:@"enabled" toObject:topicsViewController withKeyPath:@"canRefresh" options:nil];
    refreshButton.bezelStyle = NSThickSquareBezelStyle;
    refreshButton.image = [NSImage imageNamed:NSImageNameRefreshTemplate];
    refreshButton.target = topicsViewController;
    refreshButton.action = @selector(refresh);
    [self.window.contentView addSubview:refreshButton];

    [refreshButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[refreshButton(==20)]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(refreshButton)]];
    [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[refreshButton(==20)]-4-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(refreshButton)]];

    [sideBar selectButtonAtRow:RCRSideBarRowTopics];
    [topicsViewController start];
}

- (void)showMainWindow {
    [self showWindow:nil];
}

#pragma mark - EDSlidebarDelegate

- (void)sideBar:(EDSideBar*)tabBar didSelectButton:(NSInteger)index {
}

#pragma mark - NSWindowDelegate
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    if (frameSize.width > 800) {
        frameSize.width = 800;
    }
    return frameSize;
}

#pragma mark - private methods

- (void)newTopic {
    if ([RCRSettingsManager sharedRCRSettingsManager].privateToken.length == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"尚未设置密钥"
                                         defaultButton:@"设置密钥"
                                       alternateButton:@"太麻烦，不玩了"
                                           otherButton:nil
                             informativeTextWithFormat:@"发帖、查看通知等需要使用个人密钥。密钥会保存到 Keychain 中。"];
        [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    } else {
        [topicsViewController newTopic:nil];
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertDefaultReturn) {
        [(RCRPrefsController *)[RCRPrefsController sharedPrefsWindowController] showAccount];
    }
}

@end
