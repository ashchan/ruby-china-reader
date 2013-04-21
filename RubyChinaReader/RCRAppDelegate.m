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

/*
#ifdef DEBUG
    static NSString * API_ENDPOINT = @"http://localhost:3000";
#else
*/
    static NSString * API_ENDPOINT = @"http://ruby-china.org";
//#endif

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
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:API_ENDPOINT]];
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[RCRUser class]];
    [userMapping addAttributeMappingsFromArray:@[@"login", @"name", @"location", @"bio", @"tagline", @"website"]];
    [userMapping addAttributeMappingsFromDictionary:@{
        @"github_url":    @"githubUrl",
        @"gravatar_hash": @"gravatarHash",
        @"avatar_url":    @"avatarUrl"
    }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:nil keyPath:nil statusCodes:nil]];

    RKObjectMapping *topicMapping = [RKObjectMapping mappingForClass:[RCRTopic class]];
    [topicMapping addAttributeMappingsFromDictionary:@{
        @"title":           @"title",
        @"id":             @"topicId",
        //@"body":            @"body",
        //@"body_html":       @"bodyHtml",
        @"replies_count":   @"repliesCount",
        @"created_at":      @"createdDate",
        @"updated_at":      @"updatedDate",
        @"replied_at":      @"repliedAt",
        @"node_name":       @"nodeName",
        @"node_id":         @"nodeId",
        @"last_reply_user_login": @"lastReplyUserLogin"
    }];
    [topicMapping addRelationshipMappingWithSourceKeyPath:@"user" mapping:userMapping];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:topicMapping pathPattern:nil keyPath:nil statusCodes:nil]];

    RKObjectMapping *nodeMapping = [RKObjectMapping mappingForClass:[RCRNode class]];
    [nodeMapping addAttributeMappingsFromDictionary:@{
        @"_id":  @"nodeId",
        @"name": @"name"
    }];
    [manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:topicMapping pathPattern:nil keyPath:nil statusCodes:nil]];
}

@end
