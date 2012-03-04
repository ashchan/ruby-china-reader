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
#import "RCRTopic.h"

/*#ifdef DEBUG
    static NSString * API_ENDPOINT = @"http://localhost:3000";
#else*/
    static NSString * API_ENDPOINT = @"http://ruby-china.org";
//#endif

@interface RCRAppDelegate ()
- (void)mapObjects;
@end

@implementation RCRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [RKClient clientWithBaseURL:API_ENDPOINT];
    [self mapObjects];
    [[RCRAppController sharedPrefsWindowController] showWindow:nil];
}

- (void)mapObjects {
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:API_ENDPOINT];
    RKObjectMapping *topicMapping = [RKObjectMapping mappingForClass:[RCRTopic class]];
    [topicMapping mapKeyPath:@"title" toAttribute:@"title"];
    [topicMapping mapKeyPath:@"replies_count" toAttribute:@"repliesCount"];
    [topicMapping mapKeyPath:@"created_at" toAttribute:@"createdDate"];
    [topicMapping mapKeyPath:@"updated_at" toAttribute:@"updatedDate"];
    [topicMapping mapKeyPath:@"node_name" toAttribute:@"nodeName"];
    
    [manager.mappingProvider addObjectMapping:topicMapping];
}

@end
