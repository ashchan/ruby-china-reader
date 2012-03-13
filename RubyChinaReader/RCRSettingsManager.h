//
//  RCRSettingsManager.h
//  RubyChinaReader
//
//  Created by James Chen on 3/13/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCRSettingsManager : NSObject

+ (RCRSettingsManager *)sharedRCRSettingsManager;

@property (weak) NSString *privateToken;
@property BOOL startAtLogin;
@property NSInteger refreshInterval;
@property (readonly) NSInteger minRefreshInterval;
@property NSTimeInterval lastTimeRefreshed;

@end
