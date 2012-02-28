//
//  RCRAppController.m
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAppController.h"

@implementation RCRAppController

+ (NSString *)nibName {
    return @"MainMenu";
}

- (void)setupToolbar{
    //TODO
    NSView *view = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];
    [self addView:view label:@"test"];
}
    
@end
