//
//  RCRAccountViewController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRAccountViewController.h"
#import "RCRUrlBuilder.h"
#import "RCRSettingsManager.h"

@interface RCRAccountViewController ()
- (IBAction)privateTokenButtonClicked:(id)sender;
@property (weak) NSString *privateTokey;
@end

@implementation RCRAccountViewController

@dynamic privateTokey;

- (NSString *)nibName {
    return @"RCRAccountViewController";
}

- (NSImage *)image {
    return [NSImage imageNamed:NSImageNameUser];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Account";
    }
    
    return self;
}

- (NSString *)privateTokey {
    return [RCRSettingsManager sharedRCRSettingsManager].privateToken;
}

- (void)setPrivateTokey:(NSString *)token {
    [RCRSettingsManager sharedRCRSettingsManager].privateToken = token;
}

- (IBAction)privateTokenButtonClicked:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[RCRUrlBuilder urlWithPath:@"/account/edit"]];
}

@end
