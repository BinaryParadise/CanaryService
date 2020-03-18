//
//  MCLoggerUtils.h
//  MCLogger
//
//  Created by Rake Yang on 2019/2/19.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

@interface MCLoggerUtils : NSObject

/**
 存储在Keychain中的唯一标志
 */
+ (NSString *)identifier;

+ (void)setIdentifier:(NSString *)identifier;

+ (NSString *)systemName;

@end
