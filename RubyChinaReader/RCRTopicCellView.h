//
//  RCRTopicCellView.h
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RCRTopicCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *userName;
@property (assign) IBOutlet NSTextField *nodeName;
@property (assign) IBOutlet NSTextField *repliesCount;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

@end
