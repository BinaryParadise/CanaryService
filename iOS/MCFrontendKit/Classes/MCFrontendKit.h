//
//  MCFrontendKit.h
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/22.
//  Copyright © 2020 BinaryParadise. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MCParam(_key, _def) [MCFrontendKit.manager stringForKey:_key def:_def]

@interface MCFrontendKit : NSObject

/// 前端服务地址，例如 https://frontend.binaryparadise.org
@property (nonatomic, copy) NSURL *baseURL;

/// 设备唯一标识（不设置会自动生成）
@property (nonatomic, copy) NSString *deviceId;

/// 应用标识，默认为CFBundleIdentifier
@property (nonatomic, copy) NSString *appKey;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)manager;

#pragma mark - 环境配置

/// 所有环境配置
@property (nonatomic, copy, readonly) NSArray *remoteConfig;

/// 当前配置名称，未设置默认时自动取默认环境
@property (nonatomic, copy) NSString *currentName;

/// 师傅启用调试模式，默认为NO
@property (nonatomic, assign) BOOL enableDebug;

- (void)show;

/// 获取环境配置的参数值
/// @param key 参数键
/// @param def 默认值
- (NSString *)stringForKey:(NSString *)key def:(NSString *)def;

#pragma mark - 日志监控

/// 启动日志监控服务
/// @param customProfileBlock 自定义附加信息
- (void)startLogMonitor:(NSDictionary<NSString *, NSString *> * (^)(void))customProfileBlock;

@end
