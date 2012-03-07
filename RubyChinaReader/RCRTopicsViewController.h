//
//  RCRTopicsViewController.h
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "NSDate+TimeAgo.h"
#import "PullToRefreshScrollView.h"

@interface RCRTopicsViewController : NSViewController <RKObjectLoaderDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *topicsTableView;
@property (weak) IBOutlet PullToRefreshScrollView *scrollView;

- (void)refresh;
- (IBAction)userImageClicked:(id)sender;
- (IBAction)nodeNameClicked:(id)sender;

@end
