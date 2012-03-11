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
#import "RCRUser.h"
#import "RCRTopic.h"
#import "RCRTopicsViewController.h"
#import "RCRAccountViewController.h"
#import "RCROptionsViewController.h"
#import "RCRInfoViewController.h"

/*#ifdef DEBUG
    static NSString * API_ENDPOINT = @"http://localhost:3000";
#else*/
    static NSString * API_ENDPOINT = @"http://ruby-china.org";
//#endif

@interface RCRAppDelegate () {
    RCRTopicsViewController *topicsViewController;
    RCRAccountViewController *accountViewController;
    RCROptionsViewController *optionsViewController;
    RCRInfoViewController *infoViewController;
    IBOutlet NSView *contentSubview;
    IBOutlet EDSideBar *sideBar;
}

- (void)mapObjects;
@end

@implementation RCRAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self mapObjects];

    sideBar.sidebarDelegate = self;
    
    topicsViewController = [[RCRTopicsViewController alloc] init];
    [contentSubview addSubview:topicsViewController.view];
    [topicsViewController start];
}

- (void)awakeFromNib {
    [sideBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = NSDictionaryOfVariableBindings(sideBar);
    [window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[sideBar(==65)]-(>=0)-|" options:0 metrics:nil views:views]];
    [window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[sideBar]-0-|" options:0 metrics:nil views:views]];

    [contentSubview setTranslatesAutoresizingMaskIntoConstraints:NO];
    views = NSDictionaryOfVariableBindings(contentSubview);
    [window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==65)-[contentSubview]-(0)-|" options:0 metrics:nil views:views]];
    [window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentSubview]-0-|" options:0 metrics:nil views:views]];
    
    [super awakeFromNib];
}

#pragma mark - Actions

- (IBAction)aboutClicked:(id)sender {
    [(RCRAppController *)[RCRAppController sharedPrefsWindowController] showAbout];
}

- (IBAction)preferencesClicked:(id)sender {
    [(RCRAppController *)[RCRAppController sharedPrefsWindowController] showOptions];
}

- (IBAction)showMainWindow:(id)sender {
    [(RCRAppController *)[RCRAppController sharedPrefsWindowController] showMainWindow];
}

#pragma mark - EDSlidebarDelegate

- (void)sideBar:(EDSideBar*)tabBar didSelectButton:(NSInteger)index {
}

#pragma mark - Private Methods

- (void)mapObjects {
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:API_ENDPOINT]];
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[RCRUser class]];
    [userMapping mapAttributes:@"login", @"name", @"location", @"bio", @"tagline", @"website", nil];
    [userMapping mapKeyPathsToAttributes:@"github_url", @"githubUrl",
        @"gravatar_hash", @"gravatarHash",
        nil];
    [manager.mappingProvider addObjectMapping:userMapping];

    RKObjectMapping *topicMapping = [RKObjectMapping mappingForClass:[RCRTopic class]];
    [topicMapping mapKeyPathsToAttributes: @"title", @"title",
        @"_id", @"topicId",
        @"body", @"body",
        @"body_html", @"bodyHtml",
        @"replies_count", @"repliesCount",
        @"created_at", @"createdDate",
        @"updated_at", @"updatedDate",
        @"replied_at", @"repliedAt",
        @"node_name", @"nodeName",
        @"node_id", @"nodeId",
        @"last_reply_user_login", @"lastReplyUserLogin",
        nil];
    [topicMapping mapRelationship:@"user" withMapping:userMapping];
    
    [manager.mappingProvider addObjectMapping:topicMapping];
}

@end
