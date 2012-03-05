//
//  RCRTopicCellView.h
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RCRTopicCellView : NSTableCellView

@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSTextField *nodeName;
@property (weak) IBOutlet NSButton *repliesCount;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end
