//
//  RCRTopicsViewController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRTopicsViewController.h"

@interface RCRTopicsViewController ()

@end

@implementation RCRTopicsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Topics";
        [[RKClient sharedClient] get:@"api/topics.json" delegate:self];
    }
    
    return self;
}

#pragma - RKRequestDelegate
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
}

#pragma - NSTableViewDelegate

#pragma - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 10;
}

@end
