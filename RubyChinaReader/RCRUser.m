//
//  RCRUser.m
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRUser.h"
#import "EGOCache.h"

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
@synthesize avatarUrl;

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
    if (avatarUrl.length > 0) {
        return [NSURL URLWithString:avatarUrl];
    }

    return [NSURL URLWithString:[NSString stringWithFormat:@"http://gravatar.com/avatar/%@.png?s=48", gravatarHash]];
}

- (NSString *)avatarCacheKey {
    NSInteger hash = [[[[self gravatarUrl] absoluteString] description] hash];
    return [NSString stringWithFormat:@"avatar-image-%ld", hash];
}

- (void)loadGravatar {
    @synchronized (self) {
        if (self.gravatar == nil && !self.loadingGravatar) {
            __block NSImage *image = [[EGOCache currentCache] imageForKey:[self avatarCacheKey]];
            if (image) {
                @synchronized (self) {
                    loadingGravatar = NO;
                    self.gravatar = image;
                }
            } else {
                loadingGravatar = YES;
                [sharedGravatarOperationQueue() addOperationWithBlock:^(void) {
                    image = [[NSImage alloc] initWithContentsOfURL:[self gravatarUrl]];
                    if (image) {
                        @synchronized (self) {
                            loadingGravatar = NO;
                            self.gravatar = image;
                            [[EGOCache currentCache] setImage:image forKey:[self avatarCacheKey] withTimeoutInterval:60 * 60 * 24 * 7];
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
}

@end
