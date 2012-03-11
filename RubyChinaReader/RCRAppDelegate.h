//
//  RCRAppDelegate.h
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDSideBar.h"

@interface RCRAppDelegate : NSObject <NSApplicationDelegate, EDSideBarDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)aboutClicked:(id)sender;
- (IBAction)preferencesClicked:(id)sender;
- (IBAction)showMainWindow:(id)sender;

@end
