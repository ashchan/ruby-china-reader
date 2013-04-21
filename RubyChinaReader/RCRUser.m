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

static NSOperationQueue *sharedGravatarOperationQueue() {
    static NSOperationQueue *sharedGravatarOperationQueue = nil;
    if (sharedGravatarOperationQueue == nil) {
        sharedGravatarOperationQueue = [[NSOperationQueue alloc] init];
    }
    return sharedGravatarOperationQueue;    
}

- (NSURL *)gravatarUrl {
    if (self.avatarUrl.length > 0) {
        return [NSURL URLWithString:self.avatarUrl];
    }

    return [NSURL URLWithString:[NSString stringWithFormat:@"http://gravatar.com/avatar/%@.png?s=48", self.gravatarHash]];
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
                    self.loadingGravatar = NO;
                    self.gravatar = image;
                }
            } else {
                self.loadingGravatar = YES;
                [sharedGravatarOperationQueue() addOperationWithBlock:^(void) {
                    image = [[NSImage alloc] initWithContentsOfURL:[self gravatarUrl]];
                    if (image) {
                        @synchronized (self) {
                            self.loadingGravatar = NO;
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
