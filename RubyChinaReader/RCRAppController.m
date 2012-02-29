//
//  RCRAppController.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppController.h"
#import <WebKit/WebKit.h>

@interface RCRAppController() {
}

@end

@implementation RCRAppController

+ (NSString *)nibName {
    return @"MainMenu";
}

- (void)setupToolbar{
    WebView *webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
    webView.applicationNameForUserAgent = @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7";
    webView.mainFrameURL = @"http://www.ruby-china.org/topics";
    [self addView:webView label:@"Topics" image:[NSImage imageNamed:NSImageNameBonjour]];

    NSTextView *textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 300, 400)];
    [self addView:textView label:@"Account" image:[NSImage imageNamed:NSImageNameUser]];
    [self addView:textView label:@"Options" image:[NSImage imageNamed:NSImageNameAdvanced]];

    NSImageView *view = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 300, 350)];
    view.image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://l.ruby-china.org/photo/74c63894f0c9f138f233889d901f4e31.png"]];
    [self addView:view label:@"About" image:[NSImage imageNamed:NSImageNameInfo]];
}

@end
