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

/// 远程配置获取地址
@property (nonatomic, copy) NSURL *baseURL;

/// 所有环境配置
@property (nonatomic, copy, readonly) NSArray *remoteConfig;

/// 当前配置名称，未设置默认时自动取默认环境
@property (nonatomic, copy) NSString *currentName;

+ (instancetype)manager;

- (void)show;

/// 获取环境配置的参数值
/// @param key 参数键
/// @param def 默认值
- (NSString *)stringForKey:(NSString *)key def:(NSString *)def;

@end
