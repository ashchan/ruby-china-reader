//
//  RCRTopic.h
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRUser.h"

@interface RCRTopic : NSObject

@property (strong) NSNumber *topicId;
@property (strong) NSString *title;
@property (strong) NSString *body;
@property (strong) NSString *bodyHtml;
@property (strong) NSNumber *repliesCount;
@property (strong) NSDate *createdDate;
@property (strong) NSDate *updatedDate;
@property (strong) NSDate *repliedAt;
@property (strong) NSString *nodeName;
@property (strong) NSNumber *nodeId;
@property (strong) RCRUser *user;
@property (strong) NSString *lastReplyUserLogin;

@end
