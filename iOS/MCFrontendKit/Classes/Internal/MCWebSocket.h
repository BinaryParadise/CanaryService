//
//  PPWebSocket.h
//  MCLogger
//
//  Created by Rake Yang on 2019/4/7.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCWebSocketMessage.h"

NS_ASSUME_NONNULL_BEGIN

@class MCWebSocket;

/**
 消息处理协议
 */
@protocol MCMessageProtocol <NSObject>

@optional
- (void)webSocket:(MCWebSocket *)webSocket didReceiveMessage:(MCWebSocketMessage *)message;

- (void)webSocketDidOpen:(MCWebSocket *)webSocket;

- (void)webSocket:(MCWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;

@end

@interface MCWebSocket : NSObject

@property (nonatomic, copy) void (^readyStateChanged)(BOOL opened);

/**
 重试间隔描述，默认为10
 */
@property (nonatomic, assign) NSTimeInterval retryInterval;

/**
 WebSocket服务地址
 */
@property (nonatomic, copy) NSString *webSocketURL;

/**
 是否已近ready状态
 */
@property (nonatomic, assign, readonly) BOOL isReady;

+ (instancetype)shared;

- (void)start;
- (void)stop;
- (void)sendMessage:(MCWebSocketMessage *)message;

/**
 添加消息接收者

 @param reciver 消息接收者
 */
- (void)addMessageReciver:(id<MCMessageProtocol>)reciver;

@end

NS_ASSUME_NONNULL_END
