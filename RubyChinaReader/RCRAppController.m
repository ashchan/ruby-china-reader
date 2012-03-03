//
//  RCRAppController.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppController.h"

@interface RCRAppController() {
    NSTextView *_topicsView;
}

@end

@implementation RCRAppController

+ (NSString *)nibName {
    return @"MainMenu";
}

- (void)setupToolbar{
    _topicsView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 350, 400)] autorelease];
    [self addView:_topicsView label:@"Topics" image:[NSImage imageNamed:NSImageNameBonjour]];

    NSTextView *textView = [[[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 300, 400)] autorelease];
    [self addView:textView label:@"Account" image:[NSImage imageNamed:NSImageNameUser]];
    [self addView:textView label:@"Options" image:[NSImage imageNamed:NSImageNameAdvanced]];

    NSImageView *view = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 300, 350)] autorelease];
    view.image = [[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://l.ruby-china.org/photo/74c63894f0c9f138f233889d901f4e31.png"]] autorelease];
    [self addView:view label:@"About" image:[NSImage imageNamed:NSImageNameInfo]];

    [[RKClient sharedClient] get:@"api/topics.json" delegate:self];
}

- (void)dealloc {
    [super dealloc];
}

#pragma - RKRequestDelegate
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSLog(@"get back from /topics.json:");
    NSLog(response.bodyAsString);
    _topicsView.string = response.bodyAsString;
}

@end
