//
//  MCViewController.m
//  MCFrontendService
//
//  Created by Rake Yang on 02/22/2020.
//  Copyright (c) 2020 Rake Yang. All rights reserved.
//

#import "MCViewController.h"
#import <MCFrontendKit/MCFrontendKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static DDLogLevel ddLogLevel = DDLogLevelVerbose;

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
    DDLogInfo(@"加载完成");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DDLogDebug(@"将要出现");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DDLogDebug(@"将要消失");
}

- (IBAction)showConfig:(id)sender {    
    [MCFrontendKit.manager show];
    [self showDemoLogs];
}

- (void)showDemoLogs {
    DDLogError(@"%@", @"error message.");
    DDLogWarn(@"%@", @"warning message.");
    DDLogInfo(@"%@", @"info message.");
    DDLogDebug(@"%@", @"debug message.");
    DDLogVerbose(@"%@", @"verbose message.");
}

- (IBAction)logLevelChanged:(UISegmentedControl *)segmented {
    NSArray<NSNumber *> *levels = @[@(DDLogLevelVerbose), @(DDLogLevelDebug), @(DDLogLevelInfo), @(DDLogLevelWarning), @(DDLogLevelError)];
    ddLogLevel = levels[segmented.selectedSegmentIndex].integerValue;
    [self showDemoLogs];
}

@end
