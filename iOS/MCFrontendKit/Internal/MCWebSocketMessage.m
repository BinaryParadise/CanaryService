//
//  PPMessage.m
//  MCLogger
//
//  Created by Rake Yang on 2017/11/26.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

#import "MCWebSocketMessage.h"

@implementation MCWebSocketMessage

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"processed"];
}

+ (instancetype)messageWithType:(MCMessageType)type {
    MCWebSocketMessage *message = [self new];
    message.type = type;
    return message;
}

@end
