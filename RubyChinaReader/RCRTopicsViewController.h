//
//  RCRTopicsViewController.h
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "NSDate+TimeAgo.h"

@interface RCRTopicsViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

- (void)start;
- (void)refresh;
- (IBAction)newTopic:(id)sender;
- (IBAction)userImageClicked:(id)sender;

@property BOOL canRefresh;
@property BOOL canPostTopic;

@end
