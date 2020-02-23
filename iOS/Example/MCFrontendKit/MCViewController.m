//
//  MCViewController.m
//  MCFrontendService
//
//  Created by Rake Yang on 02/22/2020.
//  Copyright (c) 2020 Rake Yang. All rights reserved.
//

#import "MCViewController.h"
#import <MCFrontendKit/MCFrontendKit.h>

@interface MCViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *unsetLabel;

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.titleLabel.text = MCParam(@"title", @"未设置");
    self.textLabel.text = MCParam(@"text", nil);
    self.unsetLabel.text = MCParam(@"nani", @"没有这个参数");
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:88]];
}

- (IBAction)showConfig:(id)sender {
    [MCFrontendKit.manager show];
}

@end
