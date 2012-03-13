//
//  RCRSettingsManager.m
//  RubyChinaReader
//
//  Created by James Chen on 3/13/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRSettingsManager.h"
#import "EMKeychain.h"

@implementation RCRSettingsManager

NSString *const KeychainService         = @"RubyChina";
NSString *const KeychainUsername        = @"PrivateToken";
NSString *const LastTimeRefreshed       = @"LastTimeRefreshed";
NSString *const RefreshInterval         = @"RefreshInterval";
const NSInteger MinRefreshInterval      = 60 * 3;
const NSInteger DefaultRefreshInterval  = 3600;

SYNTHESIZE_SINGLETON_FOR_CLASS(RCRSettingsManager);

@synthesize startAtLogin;

- (void)setPrivateToken:(NSString *)privateToken {
    if (privateToken && privateToken.length > 0) {
        EMGenericKeychainItem *keychainItem = [EMGenericKeychainItem genericKeychainItemForService:KeychainService
                                                                                      withUsername:KeychainUsername];
        if (!keychainItem) {
            [EMGenericKeychainItem addGenericKeychainItemForService:KeychainService
                                                       withUsername:KeychainUsername
                                                           password:privateToken];
        } else {
            keychainItem.password = privateToken;
        }
    }
}

- (NSString *)privateToken {
    EMGenericKeychainItem *keychainItem = [EMGenericKeychainItem genericKeychainItemForService:KeychainService
                                                                                  withUsername:KeychainUsername];

    if (keychainItem) {
        return keychainItem.password;
    }
    return @"";
}

- (NSInteger)minRefreshInterval {
    return MinRefreshInterval;
}

- (NSTimeInterval)lastTimeRefreshed {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:LastTimeRefreshed];
}

- (void)setLastTimeRefreshed:(NSTimeInterval)lastTime {
    [[NSUserDefaults standardUserDefaults] setDouble:lastTime forKey:LastTimeRefreshed];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)refreshInterval {
    NSInteger interval = [[NSUserDefaults standardUserDefaults] integerForKey:RefreshInterval];
    return interval > 0 ? interval : DefaultRefreshInterval;
}

- (void)setRefreshInterval:(NSInteger)interval {
    [[NSUserDefaults standardUserDefaults] setInteger:interval forKey:RefreshInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
