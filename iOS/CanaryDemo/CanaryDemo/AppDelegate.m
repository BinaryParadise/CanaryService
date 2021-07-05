//
//  AppDelegate.m
//  CanaryDemo
//
//  Created by Rake Yang on 2020/12/13.
//

#import "AppDelegate.h"

#import "CanaryDemo-Bridging-Header.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "CanaryDemo-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    CanaryManager *shared = CanaryManager.shared;
    shared.appSecret = @"82e439d7968b7c366e24a41d7f53f47d";
    shared.deviceId = UIDevice.currentDevice.identifierForVendor.UUIDString;
    shared.baseURL = @"http://127.0.0.1";
    [DDLog addLogger:CanaryTTYLogger.shared];
    [DDLog addLogger:DDTTYLogger.sharedInstance];
    [shared startLoggerWithDomain:nil customProfile:^NSDictionary<NSString *,id> * _Nonnull{
        return @{@"test" : @"89897923561987341897", @"number": @10086, @"dict": @{@"extra": @"嵌套对象"}};
    }];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
