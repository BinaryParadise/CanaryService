//
//  AppDelegate.m
//  Example
//
//  Created by Rake Yang on 2020/3/8.
//  Copyright © 2020年 BinaryParadise. All rights reserved.
//

#import "AppDelegate.h"
#import <MCFrontendKit/MCFrontendKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
        [DDLog addLogger:DDOSLogger.sharedInstance];
    } else {
        [DDLog addLogger:DDTTYLogger.sharedInstance];
    }
    MCFrontendKit.manager.appKey = @"com.binaryparadise.neverland";
    MCFrontendKit.manager.enableDebug = YES;
    MCFrontendKit.manager.baseURL = [NSURL URLWithString:@"http://127.0.0.1/api/full"];
    MCFrontendKit.manager.currentName = @"奶味蓝";
    [MCFrontendKit.manager startLogMonitor:^NSDictionary<NSString *,id> *{
        return @{@"PushToken": @"fjejfliejglaje",
                 @"uid": @"0101010101",
                 @"num": @100982,
                 @"dict": @{@"a":@"neverland", @"b":@"life", @"n": @1988788978639}
                 };
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showPreferences:(NSMenuItem *)sender {
    [MCFrontendKit.manager show];
}

@end
