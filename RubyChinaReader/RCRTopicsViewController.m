//
//  RCRTopicsViewController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRTopicsViewController.h"
#import "RCRTableRowView.h"
#import "RCRTopicCellView.h"
#import "RCRTopic.h"
#import "RCRUserDetailViewController.h"
#import "RCRUrlBuilder.h"

@interface RCRTopicsViewController () {
    NSArray *_topics;
    NSMutableArray *_observedVisibleItems;
    NSPopover *_userPopover;
    RCRUserDetailViewController *_userDetailViewController;
    IBOutlet NSTableView *topicsTableView;
    IBOutlet NSProgressIndicator *loading;
}

- (void)reloadRowForEntity:(id)object;
- (RCRTopic *)topicForRow:(NSInteger)row;
- (RCRTopic *)topicForId:(NSInteger)topicId;
- (void)closeUserPopover;

@end

@implementation RCRTopicsViewController

- (NSString *)nibName {
    return @"RCRTopicsViewController";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Topics";
        _userPopover = [[NSPopover alloc] init];
        _userPopover.behavior = NSPopoverBehaviorApplicationDefined;
        _userDetailViewController = [[RCRUserDetailViewController alloc] init];
        _userPopover.contentViewController = _userDetailViewController;
        [self.view setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
    }

    return self;
}

- (void)start {
    // force load nib
    [_userDetailViewController view];

    topicsTableView.hidden = YES;
    topicsTableView.target = self;
    topicsTableView.doubleAction = @selector(topicRowClicked:);

    [self refresh];
}

- (void)refresh {
    loading.hidden = NO;
    [loading startAnimation:nil];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/topics.json?size=50" usingBlock:^(RKObjectLoader *loader) {
        loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[RCRTopic class]];
        loader.delegate = self;
    }];
}

#pragma mark - RKRequestDelegate

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    _topics = [objects copy];
    topicsTableView.hidden = NO;
    [loading stopAnimation:nil];
    loading.hidden = YES;

    [topicsTableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
}

- (void)request:(RKRequest *)request didReceiveData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive {
}

#pragma mark - NSTableViewDelegate

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    RCRTableRowView *rowView = [[RCRTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 300, 20)];
    rowView.objectValue = [self topicForRow:row];
    return rowView;    
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(RCRTableRowView *)rowView forRow:(NSInteger)row {
    RCRTopic *topic = rowView.objectValue;
    NSInteger index = [_observedVisibleItems indexOfObject:topic.user];
    if (index != NSNotFound) {
        [topic removeObserver:self forKeyPath:RCRTopicPropertyNamedGravatar];
        [_observedVisibleItems removeObjectAtIndex:index];
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    RCRTopic *topic = [self topicForRow:row];
    RCRTopicCellView *cellView = [topicsTableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    cellView.textField.stringValue = [NSString stringWithFormat:@"@%@", topic.user.login];
    
    NSString *statusText = @"";
    if(topic.lastReplyUserLogin.length > 0){
        statusText = [NSString stringWithFormat:@"[%@] 最后由 %@ 回复", topic.nodeName, topic.lastReplyUserLogin];
    }
    else{
        statusText = [NSString stringWithFormat:@"[%@] 由 %@ 创建", topic.nodeName, topic.user.login];
    }
    
    [cellView.nodeName setTitleWithMnemonic:statusText];
//    [cellView.nodeName setHidden:YES];
    
    [cellView.repliedAt setTitleWithMnemonic:[topic.repliedAt timeAgo]];
    
    cellView.repliesCount.title = topic.repliesCount.stringValue;
    [cellView.repliesCount.cell setHighlightsBy:0];
    [cellView.repliesCount.cell setBezelStyle:NSInlineBezelStyle];
    cellView.topicTitle.stringValue = topic.title;

    if (_observedVisibleItems == nil) {
        _observedVisibleItems = [NSMutableArray new];
    }
    if (![_observedVisibleItems containsObject:topic.user]) {
        [topic addObserver:self forKeyPath:RCRTopicPropertyNamedGravatar options:0 context:NULL];
        [topic.user loadGravatar];
        [_observedVisibleItems addObject:topic.user];
    }

    if (topic.user.gravatar == nil) {
        [cellView.progressIndicator setHidden:NO];
        [cellView.progressIndicator startAnimation:nil];
    } else {
        cellView.gravatarButton.image = topic.user.gravatar;
    }
    cellView.gravatarButton.tag = topic.topicId.integerValue;

    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [self closeUserPopover];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _topics.count;
}

#pragma mark - Actions

- (IBAction)userImageClicked:(id)sender {
    RCRTopic *topic = [self topicForId:[sender tag]];    
    if (topic) {
        if (topic.user.name.length > 0) {
            _userDetailViewController.name.stringValue = topic.user.name;
        } else {
            _userDetailViewController.name.stringValue = topic.user.login;
        }

        if (topic.user.tagline.length > 0) {
            _userDetailViewController.tagline.stringValue = topic.user.tagline;
        } else {
            _userDetailViewController.tagline.stringValue = @"这哥们儿没签名";
        }
        
        if (topic.user.location.length > 0){
            _userDetailViewController.location.stringValue = topic.user.location;
        }
        else{
            [_userDetailViewController.location setHidden:YES];
        }

        [_userPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
    }
}

- (IBAction)nodeNameClicked:(id)sender {
}

- (void)topicRowClicked:(id)sender {
    RCRTopic *topic = [self topicForRow:[sender clickedRow]];
    [[NSWorkspace sharedWorkspace] openURL:[RCRUrlBuilder urlWithPath:[NSString stringWithFormat:@"/topics/%@", topic.topicId]]];
}

#pragma mark - Private Methods & misc

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:RCRTopicPropertyNamedGravatar]) {
        [self performSelectorOnMainThread:@selector(reloadRowForEntity:) withObject:object waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)reloadRowForEntity:(id)object {
    NSInteger row = [_topics indexOfObject:object];
    if (row != NSNotFound) {
        RCRTopicCellView *cellView = [topicsTableView viewAtColumn:0 row:row makeIfNecessary:NO];
        if (cellView) {
            RCRTopic  *topic = [self topicForRow:row];
            [NSAnimationContext beginGrouping];
            [[NSAnimationContext currentContext] setDuration:0.8];
            [cellView.gravatarButton setAlphaValue:0];
            cellView.gravatarButton.image = topic.user.gravatar;
            [cellView.gravatarButton setHidden:NO];
            [[cellView.gravatarButton animator] setAlphaValue:1.0];
            [cellView.progressIndicator setHidden:YES];
            [NSAnimationContext endGrouping];
        }
    }
}

- (RCRTopic *)topicForRow:(NSInteger)row {
    return (RCRTopic *)[_topics objectAtIndex:row];
}

- (RCRTopic *)topicForId:(NSInteger)topicId {
    for (RCRTopic *topic in _topics) {
        if (topic.topicId.integerValue == topicId) {
            return topic;
        }
    }
    return nil;
}

- (void)closeUserPopover {
    if (_userPopover.shown) {
        [_userPopover close];
    }
}

@end
