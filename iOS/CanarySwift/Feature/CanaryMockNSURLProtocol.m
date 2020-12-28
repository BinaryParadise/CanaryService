//
//  CanaryMockNSURLProtocol.m
//  Canary
//
//  Created by Rake Yang on 2020/12/14.
//

#import "CanaryMockNSURLProtocol.h"
#import <objc/runtime.h>

static BOOL mockEnabled = false;
NSString * const MockURLProtocolHandledKey = @"MockURLNSProtocolHandledKey";


@interface CanaryMockNSURLProtocol () <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSMutableData *receiveData;

@end

@implementation CanaryMockNSURLProtocol

+ (void)setEnabled:(BOOL)enabled {
    mockEnabled = enabled;
    if (enabled) {
        [NSURLProtocol registerClass:self];
    } else {
        [NSURLProtocol unregisterClass:self];
    }
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    return [self canInitWithRequest:task.currentRequest];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (request) {
        if ([NSURLProtocol propertyForKey:MockURLProtocolHandledKey inRequest:request]) {
            return false;
        }
        if ([@[@"http", @"https"] containsObject:request.URL.scheme]) {
//            return [MockManager.shared shouldInterceptFor:request];
        }
        return false;
    }
    return false;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *newRequest = request.mutableCopy;
//    newRequest.URL = [MockManager.shared mockURLFor:request];
    [NSURLProtocol setProperty:@(true) forKey:MockURLProtocolHandledKey inRequest:newRequest];
    return newRequest;
}

- (void)startLoading {
    NSMutableURLRequest *newRequest = self.request.mutableCopy;
    if ([newRequest isKindOfClass:[NSMutableURLRequest class]]) {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        self.dataTask = [session dataTaskWithRequest:newRequest];
        self.receiveData = [NSMutableData data];
        [self.dataTask resume];
    }
}

- (void)stopLoading {
    [self.dataTask cancel];
    self.dataTask = nil;
    self.receiveData = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.receiveData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:@"com.alamofire.networking.task.complete" object:task userInfo:@{@"com.alamofire.networking.complete.finish.responsedata": self.receiveData ?: [NSData data]}];
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    //判断服务器返回的证书类型, 是否是服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //强制信任
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

@end

@interface NSObject (Canary)

+ (void)canary_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

+ (void)canary_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

@end

@implementation NSObject (Canary)

+ (void)canary_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:cls];
}

+ (void)canary_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

@end

/// Hook系统方法（系统每次拿到的是不同实例）
@implementation NSURLSessionConfiguration (Canary)

+ (void)load {
    [self canary_swizzleClassMethodWithOriginSel:@selector(defaultSessionConfiguration) swizzledSel:@selector(canary_defaultSessionConfiguration)];
    [self canary_swizzleClassMethodWithOriginSel:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(canary_ephemeralSessionConfiguration)];
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
    if (mockEnabled && [self respondsToSelector:@selector(protocolClasses)]
        && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: self.protocolClasses];
        Class protoCls = CanaryMockNSURLProtocol.class;
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}

@end
