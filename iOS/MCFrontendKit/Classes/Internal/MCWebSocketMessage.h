//
//  PPMessage.h
//  MCLogger
//
//  Created by Rake Yang on 2017/11/26.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

typedef NS_OPTIONS(NSUInteger, MCMessageType) {
    MCMessageTypeRegisterDevice = 10,   //注册设备信息
    MCMessageTypeDBQuery    = 20,   //数据库查询请求
    MCMessageTypeDBResult   = 21,   //数据库查询结果
    MCMessageTypeLogger     = 30,   //本地日志
    MCMessageTypeNetLogger  = 31    //网络日志
};

@interface MCWebSocketMessage : NSObject

/**
 0: 成功
 -1: 失败
 >0: 业务代码
 */
@property (nonatomic, assign) int code;

/**
 类型
 */
@property (nonatomic, assign) MCMessageType type;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSDictionary *data;

@property (nonatomic, assign) NSString *appKey;

/**
 是否已处理，默认为NO
 */
@property (nonatomic, assign) BOOL processed;

+ (instancetype)messageWithType:(MCMessageType)type;

@end
