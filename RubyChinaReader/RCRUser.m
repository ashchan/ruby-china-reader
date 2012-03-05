//
//  RCRUser.m
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRUser.h"

NSString *const RCRTopicPropertyNamedGravatar = @"user.gravatar";

@implementation RCRUser

@synthesize login;
@synthesize name;
@synthesize location;
@synthesize bio;
@synthesize tagline;
@synthesize website;
@synthesize githubUrl;
@synthesize gravatarHash;

@synthesize loadingGravatar;
@synthesize gravatar;

static NSOperationQueue *sharedGravatarOperationQueue() {
    static NSOperationQueue *sharedGravatarOperationQueue = nil;
    if (sharedGravatarOperationQueue == nil) {
        sharedGravatarOperationQueue = [[NSOperationQueue alloc] init];
    }
    return sharedGravatarOperationQueue;    
}

- (NSURL *)gravatarUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://gravatar.com/avatar/%@.png?s=48", gravatarHash]];
}

- (void)loadGravatar {
    @synchronized (self) {
        if (self.gravatar == nil && !self.loadingGravatar) {
            loadingGravatar = YES;
            [sharedGravatarOperationQueue() addOperationWithBlock:^(void) {
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:[self gravatarUrl]];
                if (image != nil) {
                    @synchronized (self) {
                        loadingGravatar = NO;
                        self.gravatar = image;
                    }
                } else {
                    @synchronized (self) {
                        self.gravatar = [NSImage imageNamed:NSImageNameTrashFull];
                    }
                }
            }];
        }
    }
}

@end
