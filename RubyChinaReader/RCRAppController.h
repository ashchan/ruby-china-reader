//
//  RCRAppController.h
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "EDSideBar.h"

@interface RCRAppController : NSWindowController <EDSideBarDelegate>

- (void)showAbout;
- (void)showOptions;
- (void)showMainWindow;

+ (RCRAppController *)sharedAppController;

@end
