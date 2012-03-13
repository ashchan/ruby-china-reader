//
//  RCRAppController.h
//  RubyChinaReader
//
//  Created by James Chen on 2/28/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "EDSideBar.h"

@interface RCRAppController : NSWindowController <NSWindowDelegate, EDSideBarDelegate>

- (void)showMainWindow;

+ (RCRAppController *)sharedAppController;

- (void)newTopic;

@end
