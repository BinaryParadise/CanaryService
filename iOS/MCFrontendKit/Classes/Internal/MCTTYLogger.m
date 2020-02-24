//
//  MCTTYLogger.m
//  MCLogger
//
//  Created by Rake Yang on 2019/4/7.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import "MCTTYLogger.h"
#import "MCWebSocket.h"
#import "MCLoggerUtils.h"

static NSArray<NSString *> *keys;
static MCTTYLogger *instance;

@implementation MCTTYLogger

#pragma mark - Init

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        keys = @[@"message",
                 @"level",
                 @"flag",
                 @"context",
                 @"file",
                 @"fileName",
                 @"function",
                 @"line",
                 @"tag",
                 @"options",
                 @"timestamp",
                 @"threadID",
                 @"threadName",
                 @"queueLabel"];
    });
    return instance;
}

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return self;
}

- (instancetype)mutableCopyWithZone:(struct _NSZone *)zone {
    return self;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    if ([MCWebSocket shared].isReady) {
        MCWebSocketMessage *mesage = [MCWebSocketMessage messageWithType:MCMessageTypeLogger];
        NSMutableDictionary *mdict = [[logMessage dictionaryWithValuesForKeys:keys] mutableCopy];
        mdict[@"appVersion"] = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        mdict[@"timestamp"] = [NSNumber numberWithLongLong:logMessage.timestamp.timeIntervalSince1970*1000];
        mdict[@"deviceId"] = [MCLoggerUtils identifier];
        mdict[@"type"] = @([self logTypeForFlag:logMessage.flag]);
        mesage.data = mdict;
        [[MCWebSocket shared] sendMessage:mesage];
    }
}

- (int)logTypeForFlag:(DDLogFlag)flag {
    switch (flag) {
        case DDLogFlagVerbose: return 0;
        case DDLogFlagDebug: return 1;
        case DDLogFlagInfo: return 2;
        case DDLogFlagWarning: return 3;
        case DDLogFlagError: return 4;
        default: return 0;
    }
}

@end
