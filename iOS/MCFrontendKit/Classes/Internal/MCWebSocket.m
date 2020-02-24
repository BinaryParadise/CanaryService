//
//  MCWebSocket.m
//  MCLogger
//
//  Created by Rake Yang on 2019/4/7.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import "MCWebSocket.h"
#import <SocketRocket/SRWebSocket.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "MCLoggerUtils.h"

@interface MCWebSocket () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *mySocket;
@property (nonatomic, strong) NSTimer *pingTimer;
@property (nonatomic, strong) NSMutableArray<id<MCMessageProtocol>> *recivers;

@end

@implementation MCWebSocket

#pragma mark - Singleton

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static MCWebSocket *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        instance.retryInterval = 10;
        instance.recivers = [NSMutableArray array];
    });
    return instance;
}

+ (instancetype)shared {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return self;
}

- (instancetype)mutableCopyWithZone:(struct _NSZone *)zone {
    return self;
}

- (BOOL)isReady {
    return self.mySocket.readyState == SR_OPEN;
}

#pragma mark - Actions

- (void)start {
    if ([self isReady]) {
        [self.mySocket close];
    }
    NSAssert(self.webSocketURL, @"请设置WebSocket服务地址");
    self.mySocket = nil;
    NSURL *fullURL = [NSURL URLWithString:[self.webSocketURL stringByAppendingFormat:@"/%@/%@", [MCLoggerUtils systemName], [MCLoggerUtils identifier]]];
    self.mySocket = [[SRWebSocket alloc] initWithURL:fullURL];
    self.mySocket.delegate = self;
    
    if (!self.pingTimer) {
        self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(_pingTimerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.pingTimer forMode:NSDefaultRunLoopMode];
    }
    [self.pingTimer fire];
    [self.mySocket open];
}

- (void)stop {
    [self.pingTimer invalidate];
    [self.mySocket close];
}

- (void)addMessageReciver:(id<MCMessageProtocol>)reciver {
    if (![self.recivers containsObject:reciver]) {
        [self.recivers addObject:reciver];
    }
}

- (void)sendMessage:(MCWebSocketMessage *)message {
    if (self.isReady) {     
        NSData *sendData = message.mj_JSONData;
        [self.mySocket send:sendData];
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    self.retryInterval = 10;
    //注册设备
    MCWebSocketMessage *message = [MCWebSocketMessage messageWithType:MCMessageTypeDeviceInfo];
    [self sendMessage:message];

    [self.recivers enumerateObjectsUsingBlock:^(id<MCMessageProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(webSocketDidOpen:)]) {
            [obj webSocketDidOpen:self];
        }
    }];
    NSLog(@"🍺WebSocket连接成功：%@", webSocket.url);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    MCWebSocketMessage *result = [MCWebSocketMessage mj_objectWithKeyValues:message];
    NSLog(@"处理消息：%lu", result.type);
    if (result) {
        if (result.code == 0) {
            [self.recivers enumerateObjectsUsingBlock:^(id<MCMessageProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj respondsToSelector:@selector(webSocket:didReceiveMessage:)]) {
                    [obj webSocket:self didReceiveMessage:result];
                    *stop = result.processed;
                }
            }];
        } else {
            NSLog(@"%@", result.msg);
        }
        
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"连接关闭：%zd-%@", code, reason);
    if (self.readyStateChanged) {
        self.readyStateChanged(NO);
    }
}

#pragma mark - Private

- (void)_pingTimerAction:(id)sender {
    SRReadyState state = self.mySocket.readyState;
    if(state == SR_OPEN) {
        NSString *pingData = @([NSDate date].timeIntervalSince1970).stringValue;
        [self.mySocket sendPing:[pingData dataUsingEncoding:NSUTF8StringEncoding]];
    }else {
        static BOOL retry = YES;
        if (retry && (state == SR_CLOSED || state == SR_CLOSING)) {
            NSLog(@"%.1f秒后重试连接", self.retryInterval);
            retry = NO;
            __weak typeof(self) self_weak = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.retryInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self_weak start];
                retry = YES;
            });
        }
    }
}

@end
