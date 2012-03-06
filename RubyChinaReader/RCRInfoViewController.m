//
//  RCRInfoViewController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/3/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRInfoViewController.h"

@interface RCRInfoViewController ()

@end

@implementation RCRInfoViewController

@synthesize appName, appVersion, credits, copyrightInfo;

- (NSString *)nibName {
    return @"RCRInfoViewController";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"About";
    }
    
    return self;
}

- (void)awakeFromNib {
    NSBundle *bundle = [NSBundle mainBundle];
    appName.stringValue = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    appVersion.stringValue = [NSString stringWithFormat:@"Version %@ (%@)",
                              [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                              [bundle objectForInfoDictionaryKey:@"CFBundleVersion"]];
    copyrightInfo.stringValue = [bundle objectForInfoDictionaryKey:@"NSHumanReadableCopyright"];
    
    NSAttributedString *creditsHtml = [[NSAttributedString alloc] initWithPath:[bundle pathForResource:@"Credits" ofType:@"html"]
                                                            documentAttributes:nil];
    [credits insertText:creditsHtml];
}

@end
