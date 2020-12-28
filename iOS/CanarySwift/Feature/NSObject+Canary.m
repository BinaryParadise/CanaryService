//
//  NSObject+Canary.m
//  Canary
//
//  Created by Rake Yang on 2020/12/14.
//

#import "NSObject+Canary.h"
#import <objc/runtime.h>

@implementation NSObject (Canary)

+ (void)canary_swizzleClassMethod:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originMethod = class_getClassMethod(cls, oriSel);
    Method swizzledMethod = class_getClassMethod(cls, swiSel);
    
    [self canary_swizzleMethod:oriSel oriMethod:originMethod swizzledSel:swiSel swizzledMethod:swizzledMethod class:cls];
}

+ (void)canary_swizzleInstanceMethod:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledMethod = class_getInstanceMethod(self, swiSel);
    
    [self canary_swizzleMethod:oriSel oriMethod:originMethod swizzledSel:swiSel swizzledMethod:swizzledMethod class:self];
}

+ (void)canary_swizzleMethod:(SEL)oriSel
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
