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
#import "RCRSettingsManager.h"

@interface RCRTopicsViewController () {
    NSArray *_topics;
    NSMutableArray *_observedVisibleItems;
    NSPopover *_userPopover;
    RCRUserDetailViewController *_userDetailViewController;
    NSTimer *_uiTimer; // update refresh button
    NSTimer *_refreshTimer;
    IBOutlet NSTableView *topicsTableView;
    IBOutlet NSProgressIndicator *loading;
}

- (void)reloadRowForEntity:(id)object;
- (RCRTopic *)topicForRow:(NSInteger)row;
- (RCRTopic *)topicForId:(NSInteger)topicId;
- (void)closeUserPopover;
- (void)createRefreshTimer;

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
        _uiTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(uiTimerUpdated) userInfo:nil repeats:YES];

        [[RCRSettingsManager sharedRCRSettingsManager] addObserver:self forKeyPath:@"refreshInterval" options:NSKeyValueObservingOptionNew context:nil];
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
    [RCRSettingsManager sharedRCRSettingsManager].lastTimeRefreshed = [[NSDate date] timeIntervalSince1970];
    [self setCanRefresh:NO];
    loading.hidden = NO;
    [loading startAnimation:nil];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/topics.json?size=50" usingBlock:^(RKObjectLoader *loader) {
        loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[RCRTopic class]];
        loader.delegate = self;
    }];

    [self createRefreshTimer];
}

- (BOOL)canRefresh {
    return [[NSDate date] timeIntervalSince1970] - [RCRSettingsManager sharedRCRSettingsManager].lastTimeRefreshed >= [RCRSettingsManager sharedRCRSettingsManager].minRefreshInterval;
}

- (void)setCanRefresh:(BOOL)yesOrNo {
    // just trigger KVO
}

- (void)uiTimerUpdated {
    [self setCanRefresh:YES];
}

- (void)createRefreshTimer {
    [_refreshTimer invalidate];
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:[RCRSettingsManager sharedRCRSettingsManager].refreshInterval
                                                     target:self
                                                   selector:@selector(refreshTimerUpdated)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)refreshTimerUpdated {
    [self refresh];
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
    if (topic.lastReplyUserLogin.length > 0) {
        statusText = [NSString stringWithFormat:@"[%@] 最后由 %@ 回复", topic.nodeName, topic.lastReplyUserLogin];
    }
    else {
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
        NSMutableAttributedString *userName = [[NSMutableAttributedString alloc] initWithString:(topic.user.name.length > 0 ? topic.user.name : topic.user.login)];
        NSRange range = NSMakeRange(0, userName.length);
        [userName addAttribute:NSLinkAttributeName
                         value:[RCRUrlBuilder urlWithPath:[NSString stringWithFormat:@"/users/%@", topic.user.login]]
                         range:range];
        [userName addAttribute:NSForegroundColorAttributeName
                         value:[NSColor blueColor]
                         range:range];
        [userName addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInt:NSSingleUnderlineStyle]
                         range:range];
        _userDetailViewController.name.allowsEditingTextAttributes = YES;    
        _userDetailViewController.name.attributedStringValue = userName;

        if (topic.user.tagline.length > 0) {
            _userDetailViewController.tagline.stringValue = topic.user.tagline;
        } else {
            _userDetailViewController.tagline.stringValue = @"这哥们儿没签名";
        }
        
        if (topic.user.location.length > 0){
            [_userDetailViewController.location setHidden:NO];
            _userDetailViewController.location.stringValue = topic.user.location;
        }
        else{
            [_userDetailViewController.location setHidden:YES];
        }

        [_userPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
    }
}

- (void)topicRowClicked:(id)sender {
    RCRTopic *topic = [self topicForRow:[sender clickedRow]];
    [[NSWorkspace sharedWorkspace] openURL:[RCRUrlBuilder urlWithPath:[NSString stringWithFormat:@"/topics/%@", topic.topicId]]];
}

- (IBAction)newTopic:(id)sender {
    NSString *token = [RCRSettingsManager sharedRCRSettingsManager].privateToken;
    //todo
}

#pragma mark - Private Methods & misc

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:RCRTopicPropertyNamedGravatar]) {
        [self performSelectorOnMainThread:@selector(reloadRowForEntity:) withObject:object waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        return;
    }

    if ([keyPath isEqualToString:@"refreshInterval"]) {
        [self createRefreshTimer];
        return;
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
