//
//  RCRInfoViewController.h
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RCRInfoViewController : NSViewController

@property (weak) IBOutlet NSTextField *appName;
@property (weak) IBOutlet NSTextField *appVersion;
@property (assign) IBOutlet NSTextView *credits;
@property (weak) IBOutlet NSTextField *copyrightInfo;

@end
