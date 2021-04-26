//
//  MockConfig.m
//  Canary
//
//  Created by Rake Yang on 2021/4/26.
//

#import "MockConfig.h"
#import "Canary-Swift.h"

@implementation MockConfig

+ (void)load {
    //用以初始化Mock
    if (CanaryMockURLProtocol.isEnabled) {
        [CanarySwift shared];
    }
}

@end
