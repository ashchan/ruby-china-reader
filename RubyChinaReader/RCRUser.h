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

@property (retain) NSString *login;
@property (retain) NSString *name;
@property (retain) NSString *location;
@property (retain) NSString *bio;
@property (retain) NSString *tagline;
@property (retain) NSString *website;
@property (retain) NSString *githubUrl;
@property (retain) NSString *gravatarHash;

@property (assign) BOOL loadingGravatar;
@property (retain) NSImage *gravatar;

- (void)loadGravatar;

@end
