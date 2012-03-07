//
//  RCRTopicDetailController.h
//  RubyChinaReader
//
//  Created by James Chen on 3/7/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RCRTopic;

@interface RCRTopicDetailController : NSWindowController

@property (assign) IBOutlet NSTextView *topicView;

- (id)initWithTopic:(RCRTopic *)topic;

@end
