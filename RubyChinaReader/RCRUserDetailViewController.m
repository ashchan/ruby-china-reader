//
//  RCRUserDetailViewController.m
//  RubyChinaReader
//
//  Created by James Chen on 3/7/12.
//  Copyright (c) 2012 ashchan.com. All rights reserved.
//

#import "RCRUserDetailViewController.h"

@interface RCRUserDetailViewController ()

@end

@implementation RCRUserDetailViewController

@synthesize name, tagline, location;

- (NSString *)nibName {
    return @"RCRUserDetailViewController";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
