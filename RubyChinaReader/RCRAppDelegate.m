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
#import "RCRPrefsController.h"
#import "RCRUser.h"
#import "RCRTopic.h"
#import "RCRNode.h"

@interface RCRAppDelegate () {
}

- (void)mapObjects;
@end

@implementation RCRAppDelegate

#ifdef DEBUG
    static NSString * API_ENDPOINT = @"http://localhost:3000";
#else
    static NSString * API_ENDPOINT = @"http://ruby-china.org";
#endif

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self mapObjects];
    
    [[RCRAppController sharedAppController] showWindow:nil];
}

#pragma mark - Actions

- (IBAction)aboutClicked:(id)sender {
    [(RCRPrefsController *)[RCRPrefsController sharedPrefsWindowController] showAbout];
}

- (IBAction)preferencesClicked:(id)sender {
    [(RCRPrefsController *)[RCRPrefsController sharedPrefsWindowController] showPreferences];
}

- (IBAction)showMainWindow:(id)sender {
    [[RCRAppController sharedAppController] showMainWindow];
}

- (IBAction)closeWindow:(id)sender {
    [[NSApp keyWindow] close];
}

- (IBAction)newTopicClicked:(id)sender {
    [[RCRAppController sharedAppController] newTopic];
}

#pragma mark - Private Methods

- (void)mapObjects {
    [RKClient clientWithBaseURLString:API_ENDPOINT];
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:API_ENDPOINT]];
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[RCRUser class]];
    [userMapping mapAttributes:@"login", @"name", @"location", @"bio", @"tagline", @"website", nil];
    [userMapping mapKeyPathsToAttributes:@"github_url", @"githubUrl",
        @"gravatar_hash", @"gravatarHash",
        @"avatar_url", @"avatarUrl",
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

    RKObjectMapping *nodeMapping = [RKObjectMapping mappingForClass:[RCRNode class]];
    [nodeMapping mapKeyPathsToAttributes:@"_id", @"nodeId",
        @"name", @"name", nil];
    [manager.mappingProvider addObjectMapping:nodeMapping];
}

@end
