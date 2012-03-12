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

NSString *const KeychainService     = @"RubyChina";
NSString *const KeychainUsername    = @"PrivateToken";

SYNTHESIZE_SINGLETON_FOR_CLASS(RCRSettingsManager);

@synthesize startAtLogin, refreshInterval;

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

@end
