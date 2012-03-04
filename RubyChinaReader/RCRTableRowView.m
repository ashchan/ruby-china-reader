//
//  RCRTableRowView.m
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRTableRowView.h"

@implementation RCRTableRowView

@synthesize objectValue = _objectValue;

- (void)dealloc {
    self.objectValue = nil;
    [super dealloc];
}

@end
