//
//  MCFrontendKit.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/22.
//  Copyright © 2020 BinaryParadise. All rights reserved.
//

#import "MCFrontendKit.h"
#import "MCFrontendKitViewController.h"

#define kMCSuiteName @"com.binaryparadise.frontendkit"
#define kMCRemoteConfig @"remoteConfig"
#define kMCCurrentName @"currenName"

@interface MCFrontendKit ()

@property (nonatomic, copy) NSArray *remoteConfig;
@property (nonatomic, strong) UIWindow *currentWindow;
@property (nonatomic, strong) NSUserDefaults *frontendDefaults;
@property (nonatomic, copy) NSDictionary *selectedConfig;

@end

@implementation MCFrontendKit

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frontendDefaults = [[NSUserDefaults alloc] initWithSuiteName:kMCSuiteName];
        self.remoteConfig = [self.frontendDefaults objectForKey:kMCRemoteConfig];
        _currentName = [self.frontendDefaults objectForKey:kMCCurrentName];
        [self switchToCurrentConfig];
    }
    return self;
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static MCFrontendKit *instance;
    dispatch_once(&onceToken, ^{
        instance = [self.alloc init];
    });
    return instance;
}

- (void)setBaseURL:(NSURL *)baseURL {
    _baseURL = baseURL;
    [self fetchRemoteConfig:^{
        
    }];
}

- (void)setCurrentName:(NSString *)currentName {
    _currentName = currentName;
    [self.frontendDefaults setObject:currentName forKey:kMCCurrentName];
    [self.frontendDefaults synchronize];
}

- (void)show {
    void(^showController)(void) = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:MCFrontendKitViewController.new];
            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        });
    };
    
    [self fetchRemoteConfig:showController];
}

- (void)fetchRemoteConfig:(void (^)(void))completion {
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:self.baseURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [self processRemoteConfig:dict];
        }
        if (completion) {
            completion();
        }
    }];
    [task resume];
}

- (void)processRemoteConfig:(NSDictionary *)dict {
    NSNumber *code = dict[@"code"];
    if (code.intValue == 0) {
        if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
            self.remoteConfig = dict[@"data"];
            [self.frontendDefaults setObject:self.remoteConfig forKey:kMCRemoteConfig];
            [self switchToCurrentConfig];
        }
    }
}

- (void)switchToCurrentConfig {
    NSDictionary *selectedItem;
    NSDictionary *defaultItem;
    for (NSDictionary *group in self.remoteConfig) {
        for (NSDictionary *item in group[@"items"]) {
            if ([item[@"defaultTag"] boolValue]) {
                defaultItem = item;
            }
            if ([item[@"name"] isEqualToString:self.currentName]) {
                selectedItem = item;
            }
        }
    }
    
    if (!selectedItem) {
        selectedItem = defaultItem;
    }
    
    self.selectedConfig = selectedItem;
}

- (NSString *)stringForKey:(NSString *)key def:(NSString *)def {
    NSArray *subItems = self.selectedConfig[@"subItems"];
    NSDictionary *dict = [subItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name=%@", key]].firstObject;
    NSString *value = dict[@"value"];
    return value?:def;
}

@end
