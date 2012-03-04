//
//  RCRTopicsViewController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRTopicsViewController.h"
#import "RCRTopic.h"

@interface RCRTopicsViewController () {
    NSArray *_topics;
}
@end

@implementation RCRTopicsViewController

@synthesize topicsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Topics";
        RKObjectMapping *topicMappping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[RCRTopic class]];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/topics.json" objectMapping:topicMappping delegate:self];
    }
    
    return self;
}

#pragma mark - RKRequestDelegate
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
}

#pragma mark - RKObjectLoaderDelegate
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    _topics = objects;
    [topicsTableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
}


#pragma mark - NSTableViewDelegate

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_topics count];
}

@end
