//
//  CanaryMockNSURLProtocol.h
//  Canary
//
//  Created by Rake Yang on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class MockManager;

@interface CanaryMockNSURLProtocol : NSURLProtocol

+ (void)setEnabled:(BOOL)enabled;

@end
