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
#import "RCRNode.h"

@interface RCRTopicsViewController () {
    NSArray *_topics;
    NSArray *_nodes;
    NSMutableArray *_observedVisibleItems;
    NSPopover *_userPopover;
    RCRUserDetailViewController *_userDetailViewController;
    NSTimer *_uiTimer; // update refresh button
    NSTimer *_refreshTimer;
    IBOutlet NSTableView *topicsTableView;
    IBOutlet NSProgressIndicator *loading;
    IBOutlet NSWindow *newTopicPanel;
    IBOutlet NSTextField *newTopicTitle;
    IBOutlet NSTextView *newTopicBody;
    IBOutlet NSPopUpButton *newTopicNode;
}

- (void)reloadRowForEntity:(id)object;
- (RCRTopic *)topicForRow:(NSInteger)row;
- (RCRTopic *)topicForId:(NSInteger)topicId;
- (void)closeUserPopover;
- (void)createRefreshTimer;
- (void)fetchNodes;
- (void)clearNewTopic;

- (IBAction)submitTopic:(id)sender;

@end

@implementation RCRTopicsViewController

NSString *const SELECT_NODE = @"--选择一个节点--";

@synthesize canPostTopic;

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
    [self fetchNodes];
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
    if (response.statusCode == 201) {
        [self clearNewTopic];
        [NSApp endSheet:newTopicPanel returnCode:NSRunStoppedResponse];
    }
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if (objectLoader.objectMapping.objectClass == [RCRTopic class]) {
        _topics = [objects copy];
        topicsTableView.hidden = NO;
        [loading stopAnimation:nil];
        loading.hidden = YES;

        [topicsTableView reloadData];
    } else if (objectLoader.objectMapping.objectClass == [RCRNode class]) {
        _nodes = [objects copy];
        self.canPostTopic = YES;
    }
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
    [newTopicNode removeAllItems];
    [newTopicNode addItemWithTitle:SELECT_NODE];
    [newTopicNode lastItem].tag = -1;
    for (RCRNode *node in _nodes) {
        [newTopicNode addItemWithTitle:node.name];
        [newTopicNode lastItem].tag = node.nodeId.integerValue;
    }

    [NSApp beginSheet:newTopicPanel
       modalForWindow:[NSApp keyWindow]
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:nil];
}

- (IBAction)submitTopic:(id)sender {
    if ([sender tag] == 1) {
        BOOL hasError = NO;

        NSInteger node_id = newTopicNode.selectedTag;
        if (newTopicTitle.stringValue.length == 0) {
            hasError = YES;
            newTopicTitle.backgroundColor = [NSColor redColor];
        }
        else {
            newTopicTitle.backgroundColor = [NSColor textBackgroundColor];
        }

        if (newTopicBody.string.length == 0) {
            hasError = YES;
            newTopicBody.backgroundColor = [NSColor redColor];
        } else {
            newTopicBody.backgroundColor = [NSColor textBackgroundColor];
        }

        if (node_id == -1) {
            hasError = YES;
            NSMutableAttributedString *error = [[NSMutableAttributedString alloc] initWithString:SELECT_NODE];
            [error addAttribute:NSBackgroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0, error.length)];
            newTopicNode.selectedItem.attributedTitle = error;
        } else {
            [newTopicNode itemAtIndex:0].attributedTitle = nil;
        }

        if (!hasError) {
            NSDictionary* params = [NSDictionary dictionaryWithKeysAndObjects:@"title", newTopicTitle.stringValue,
                                                                          @"body", newTopicBody.string,
                                                                          @"node_id", [NSNumber numberWithInteger:newTopicNode.selectedTag],
                                                                          @"token", [RCRSettingsManager sharedRCRSettingsManager].privateToken,
                                                                          nil];
            [[RKClient sharedClient] post:@"/api/topics.json" params:params delegate:self];
        } else {
            newTopicPanel.viewsNeedDisplay = YES;
        }
    } else {
        [NSApp endSheet:newTopicPanel returnCode:NSRunAbortedResponse];
        [self clearNewTopic];
    }
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [newTopicPanel orderOut:self];
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

- (void)fetchNodes {
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/api/nodes.json" usingBlock:^(RKObjectLoader *loader) {
        loader.objectMapping = [[RKObjectManager sharedManager].mappingProvider objectMappingForClass:[RCRNode class]];
        loader.delegate = self;
    }];
}

- (void)clearNewTopic {
    newTopicTitle.stringValue = @"";
    newTopicBody.string = @"";
    [newTopicNode selectItemAtIndex:0];
}

@end
