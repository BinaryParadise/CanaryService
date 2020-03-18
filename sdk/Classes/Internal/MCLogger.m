//
//  MCLogger.m
//  MCLogger
//
//  Created by Rake Yang on 2017/12/16.
//  Copyright © 2017年 BinaryParadise. All rights reserved.
//

#import "MCLogger.h"
#import "MCLoggerUtils.h"
#import "MCWebSocket.h"
#import "MCTTYLogger.h"
#import "MCDevice.h"

@interface MCLogger () <MCMessageProtocol>

@property (nonatomic, copy) NSString *appKey;

@end

@implementation MCLogger

+ (instancetype)sharedInstance {
    static MCLogger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self.alloc init];
    });
    return instance;
}

- (void)setIdentifier:(NSString *)identifier {
    [MCLoggerUtils setIdentifier:identifier];
}

- (NSString *)identifier {
    return [MCLoggerUtils identifier];
}

- (void)startWithAppKey:(NSString *)appKey domain:(NSURL *)domain {
    self.appKey = appKey;
    [DDLog addLogger:[MCTTYLogger sharedInstance]];
    [MCWebSocket shared].webSocketURL = domain.absoluteString;
    [MCWebSocket.shared addMessageReciver:self];
    [[MCWebSocket shared] start];
}

#pragma mark - MCMessageProtocol

- (void)registerDevice:(MCWebSocket *)webSocket {
    MCWebSocketMessage *msg = [MCWebSocketMessage messageWithType:MCMessageTypeRegisterDevice];
    msg.appKey = self.appKey;
    MCDevice *device = MCDevice.new;
    device.deviceId = [self identifier];
    device.appKey = self.appKey;
    if (self.customProfileBlock) {
        device.profile = self.customProfileBlock();
    }
    msg.data = [device mj_JSONObject];
    [webSocket sendMessage:msg];
}

- (void)webSocketDidOpen:(MCWebSocket *)webSocket {
    [self registerDevice:webSocket];
}

- (void)webSocket:(MCWebSocket *)webSocket didReceiveMessage:(MCWebSocketMessage *)message {
    
}

- (void)webSocket:(MCWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    [self registerDevice:webSocket];
}

@end
