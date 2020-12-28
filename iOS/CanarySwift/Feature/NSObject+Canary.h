//
//  NSObject+Canary.h
//  Canary
//
//  Created by Rake Yang on 2020/12/14.
//

#import <Foundation/Foundation.h>

@interface NSObject (Canary)

+ (void)canary_swizzleClassMethod:(SEL)oriSel swizzledSel:(SEL)swiSel;

+ (void)canary_swizzleInstanceMethod:(SEL)oriSel swizzledSel:(SEL)swiSel;

@end
