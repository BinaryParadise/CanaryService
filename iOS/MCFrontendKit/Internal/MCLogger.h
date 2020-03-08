//
//  MCLogger.h
//
//  Created by Rake Yang on 2017/12/16.
//  Copyright © 2017年 BinaryParadise. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface MCLogger : NSObject

/// 自定义的附加信息
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * (^customProfileBlock)(void);

+ (instancetype)sharedInstance;

/// 启动日志收集
/// @param appKey AppKey
/// @param domain 域名
- (void)startWithAppKey:(NSString *)appKey domain:(NSURL *)domain;

@end
