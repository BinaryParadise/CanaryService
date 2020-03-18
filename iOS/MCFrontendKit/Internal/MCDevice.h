//
//  MCDevice.h
//  MCLogger
//
//  Created by Rake Yang on 2020/2/19.
//

#import <Foundation/Foundation.h>

@interface MCDevice : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<NSString *> *databases;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSDictionary<NSString *, NSDictionary *> *ipAddrs;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *osName;
@property (nonatomic, copy) NSString *osVersion;
@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *profile;
@property (nonatomic, assign) BOOL simulator;

@end
