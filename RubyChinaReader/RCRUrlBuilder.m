//
//  RCRUrlBuilder.m
//  RubyChinaReader
//
//  Created by James Chen on 3/7/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRUrlBuilder.h"

@implementation RCRUrlBuilder

NSString *const RubyChinaUrl = @"http://ruby-china.org";

+ (NSURL *)urlWithPath:(NSString *)path {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", RubyChinaUrl, path]];
}

@end
