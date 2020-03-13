//
//  MCAppDelegate.m
//  MCFrontendService
//
//  Created by Rake Yang on 02/22/2020.
//  Copyright (c) 2020 Rake Yang. All rights reserved.
//

#import "MCAppDelegate.h"
#import <MCFrontendKit/MCFrontendKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
        [DDLog addLogger:DDOSLogger.sharedInstance];
    } else {
        [DDLog addLogger:DDTTYLogger.sharedInstance];
    }
    MCFrontendKit.manager.appKey = @"com.binaryparadise.neverland";
    MCFrontendKit.manager.enableDebug = YES;
    MCFrontendKit.manager.baseURL = [NSURL URLWithString:@"https://y.neverland.life/api/conf/full"];
    MCFrontendKit.manager.currentName = @"奶味蓝";
    [MCFrontendKit.manager startLogMonitor:^NSDictionary<NSString *,NSString *> *{
        return @{@"PushToken": @"fjejfliejglaje",
                 @"uid": @"0101010101",
                 @"num": @100982,
                 @"dict": @{@"a":@"neverland", @"b":@"life", @"n": @1988788978639}
                };
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
