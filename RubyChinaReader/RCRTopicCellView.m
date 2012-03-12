//
//  RCRTopicCellView.m
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRTopicCellView.h"

@implementation RCRTopicCellView

@synthesize topicTitle, nodeName, gravatarButton, repliesCount, repliedAt, progressIndicator;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)viewWillDraw {
    [super viewWillDraw];
    [self.nodeName sizeToFit];
}

@end
