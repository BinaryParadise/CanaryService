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
    static NSString *identifierString;
    dispatch_once(&onceToken, ^{
        identifierString = [SAMKeychain passwordForService:kBundleIdentifier account:kLoggerServiceName];
        if (identifierString.length == 0) {
#if TARGET_OS_OSX
            identifierString = [NSUUID UUID].UUIDString;
            [SAMKeychain setPassword:identifierString forService:kBundleIdentifier account:kLoggerServiceName];
#else
            identifierString = [UIDevice currentDevice].identifierForVendor.UUIDString;
            [SAMKeychain setPassword:identifierString forService:kBundleIdentifier account:kLoggerServiceName];
#endif
        }
    });
    return identifierString;
}

+ (void)setIdentifier:(NSString *)identifier {
    [SAMKeychain setPassword:identifier forService:kBundleIdentifier account:kLoggerServiceName];
}

+ (NSString *)systemName {
#if TARGET_OS_OSX
    return @"macOS";
#else
    return [UIDevice currentDevice].systemName;
#endif
}

@end
