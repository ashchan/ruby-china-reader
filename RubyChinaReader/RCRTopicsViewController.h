//
//  RCRTopicsViewController.h
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "PullToRefreshScrollView.h"

@interface RCRTopicsViewController : NSViewController <RKObjectLoaderDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *topicsTableView;
@property (weak) IBOutlet PullToRefreshScrollView *scrollView;

- (void)refresh;

@end
