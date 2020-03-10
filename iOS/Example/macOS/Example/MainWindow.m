//
//  MainWindow.m
//  macOS
//
//  Created by Rake Yang on 2020/3/8.
//  Copyright © 2020年 BinaryParadise. All rights reserved.
//

#import "MainWindow.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static DDLogLevel ddLogLevel = DDLogLevelVerbose;

@implementation MainWindow

- (IBAction)testLogger:(id)sender {
    DDLogError(@"%@", @"error message.");
    DDLogWarn(@"%@", @"warning message.");
    DDLogInfo(@"%@", @"info message.");
    DDLogDebug(@"%@", @"debug message.");
    DDLogVerbose(@"%@", @"verbose message.");
}

@end
