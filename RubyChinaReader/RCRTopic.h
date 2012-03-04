//
//  RCRTopic.h
//  RubyChinaReader
//
//  Created by James Chen on 3/4/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCRTopic : NSObject

@property (assign) NSString *title;
@property (assign) NSNumber *repliesCount;
@property (assign) NSDate *createdDate;
@property (assign) NSDate *updatedDate;
@property (assign) NSString *nodeName;

@end
