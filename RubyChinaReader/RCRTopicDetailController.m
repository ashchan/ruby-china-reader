//
//  RCRTopicDetailController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/7/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRTopicDetailController.h"
#import "RCRTopic.h"

@interface RCRTopicDetailController () {
    RCRTopic *_topic;
}
@end

@implementation RCRTopicDetailController

@synthesize topicView;

- (id)initWithTopic:(RCRTopic *)topic {
    if (self = [super initWithWindowNibName:@"RCRTopicDetailController"]) {
        _topic = topic;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSString *htmlBody = @"<!DOCTYPE html><html><head><meta charset='utf-8'></head><body>";
    htmlBody = [htmlBody stringByAppendingString:_topic.bodyHtml];
    htmlBody = [htmlBody stringByAppendingString:@"</body></html>"];

    NSData *htmlData = [htmlBody dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *html = [[NSAttributedString alloc] initWithHTML:htmlData
                                                                options:nil
                                                     documentAttributes:nil];
    [topicView insertText:html];
}

@end
