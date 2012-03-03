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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"About";
        
        NSImageView *view = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 300, 350)] autorelease];
        [self.view addSubview:view];
        [self performSelectorInBackground:@selector(loadImage) withObject:nil];
    }
    
    return self;
}

- (void)loadImage {
    ((NSImageView *)[self.view.subviews objectAtIndex:0]).image = [[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://l.ruby-china.org/photo/74c63894f0c9f138f233889d901f4e31.png"]] autorelease];
}

@end
