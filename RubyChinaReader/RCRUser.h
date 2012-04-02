//
//  RCRUser.h
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RCRTopicPropertyNamedGravatar;

@interface RCRUser : NSObject

@property (strong) NSString *login;
@property (strong) NSString *name;
@property (strong) NSString *location;
@property (strong) NSString *bio;
@property (strong) NSString *tagline;
@property (strong) NSString *website;
@property (strong) NSString *githubUrl;
@property (strong) NSString *gravatarHash;
@property (strong) NSString *avatarUrl;

@property (assign) BOOL loadingGravatar;
@property (strong) NSImage *gravatar;

- (void)loadGravatar;

@end
