//
//  PPWebSocket.h
//  MCLogger
//
//  Created by Rake Yang on 2019/4/7.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

/**
 本地日志转发
 */
@interface MCTTYLogger : DDAbstractLogger <DDLogger>

+ (instancetype)sharedInstance;

@end
