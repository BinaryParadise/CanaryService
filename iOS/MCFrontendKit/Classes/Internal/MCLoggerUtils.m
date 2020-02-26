//
//  MCLoggerUtils.m
//  MCLogger
//
//  Created by Rake Yang on 2019/2/19.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import "MCLoggerUtils.h"
#import <SAMKeychain/SAMKeychain.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

#define kLoggerServiceName  @"MCIdentifierForVendor"
#define kBundleIdentifier   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

@implementation MCLoggerUtils

+ (NSString *)identifier {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *identifierString = [SAMKeychain passwordForService:kBundleIdentifier account:kLoggerServiceName];
        if (identifierString.length == 0) {
#if TARGET_OS_OSX
            [SAMKeychain setPassword:[NSUUID UUID].UUIDString forService:kBundleIdentifier account:kLoggerServiceName];
#else
            [SAMKeychain setPassword:[UIDevice currentDevice].identifierForVendor.UUIDString forService:kBundleIdentifier account:kLoggerServiceName];
#endif
        }
    });
    return [SAMKeychain passwordForService:kBundleIdentifier account:kLoggerServiceName];
}

+ (void)setIdentifier:(NSString *)identifier {
    [SAMKeychain setPassword:identifier forService:kBundleIdentifier account:kLoggerServiceName];
}

+ (NSString *)systemName {
#if TARGET_OS_OSX
    return [NSHost currentHost].name;
#else
    return [UIDevice currentDevice].systemName;
#endif
}

@end
