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

@property (retain) NSNumber *topicId;
@property (retain) NSString *title;
@property (retain) NSString *body;
@property (retain) NSString *bodyHtml;
@property (retain) NSNumber *repliesCount;
@property (retain) NSDate *createdDate;
@property (retain) NSDate *updatedDate;
@property (retain) NSString *nodeName;
@property (retain) NSNumber *nodeId;
@property (retain) RCRUser *user;

@end
