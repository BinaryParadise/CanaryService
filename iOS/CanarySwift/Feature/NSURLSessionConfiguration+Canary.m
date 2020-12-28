//
//  NSURLSessionConfiguration+Canary.m
//  Canary
//
//  Created by Rake Yang on 2020/12/14.
//

#import "NSURLSessionConfiguration+Canary.h"
#import "NSObject+Canary.h"
#import <objc/runtime.h>

@implementation NSURLSessionConfiguration (Canary)

+ (void)setCustomProtocolClass:(Class)customProtocolClass {
    objc_setAssociatedObject(self, @selector(customProtocolClass), customProtocolClass, OBJC_ASSOCIATION_ASSIGN);
}

+ (Class)customProtocolClass {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)load {
    /// 系统提供的实例非唯一
    [self canary_swizzleClassMethod:@selector(defaultSessionConfiguration) swizzledSel:@selector(canary_defaultSessionConfiguration)];
    [self canary_swizzleClassMethod:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(canary_ephemeralSessionConfiguration)];
}

+ (NSURLSessionConfiguration *)canary_defaultSessionConfiguration {
    NSURLSessionConfiguration *config = [self canary_defaultSessionConfiguration];
    [config addCanaryNSURLProtocol];
    return config;
}

+ (NSURLSessionConfiguration *)canary_ephemeralSessionConfiguration {
    NSURLSessionConfiguration *config = [self canary_ephemeralSessionConfiguration];
    [config addCanaryNSURLProtocol];
    return config;
}

- (void)addCanaryNSURLProtocol {
    if ([self.class customProtocolClass] && [self respondsToSelector:@selector(protocolClasses)]
        && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: self.protocolClasses];
        Class protoCls = [self.class customProtocolClass];
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}

@end
