//
//  UIView+MCFrameGeometry.m
//  MCUIKit
//
//  Created by Rake Yang on 2017/11/6.
//  Copyright © 2017年 MC-Studio. All rights reserved.
//

#import "UIView+Geometry.h"

@implementation UIView (Geometry)

- (CGFloat)mcTop {
    return self.frame.origin.y;
}

- (void)setMcTop:(CGFloat)top {
    NSAssert(!isnan(top), @"Not a Number");
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)mcLeft {
    return self.frame.origin.x;
}

- (void)setMcLeft:(CGFloat)left {
    NSAssert(!isnan(left), @"Not a Number");
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)mcBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMcBottom:(CGFloat)bottom {
    CGRect newFrame = self.frame;
    newFrame.origin.y = bottom - newFrame.size.height;
    self.frame = newFrame;
}

- (CGFloat)mcRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setMcRight:(CGFloat)right {
    NSAssert(!isnan(right), @"Not a Number");
    CGRect newFrame = self.frame;
    newFrame.origin.x = right - newFrame.size.width;
    self.frame = newFrame;
}

- (CGFloat)mcWidth {
    return self.frame.size.width;
}

- (void)setMcWidth:(CGFloat)width {
    NSAssert(!isnan(width), @"Not a Number");
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)mcHeight {
    return self.frame.size.height;
}

- (void)setMcHeight:(CGFloat)height {
    NSAssert(!isnan(height), @"Not a Number");
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGPoint)mcOrigin {
    return self.frame.origin;
}

- (void)setMcOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGSize)mcSize {
    return self.frame.size;
}

- (void)setMcSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

#pragma mark - 以指定原点相对位置计算

- (CGPoint)mcLeftBottom {
    NSAssert(self.superview, @"need a superview!");
    return CGPointMake(self.frame.origin.x, self.superview.frame.size.height - self.frame.origin.y - self.frame.size
                       .height);
}

- (void)setMcLeftBottom:(CGPoint)leftBottom {
    NSAssert(self.superview, @"need a superview!");
    CGRect frame = self.frame;
    frame.origin = CGPointMake(leftBottom.x, self.superview.frame.size.height + leftBottom.y - frame.size.height);
    self.frame = frame;
}

- (CGPoint)mcRightTop {
    NSAssert(self.superview, @"need a superview!");
    CGRect frame = self.frame;
    return CGPointMake(frame.origin.x + frame.size.width - self.superview.frame.size.width, frame.origin.y);
}

- (void)setMcRightTop:(CGPoint)rightTop {
    NSAssert(self.superview, @"need a superview!");
    CGRect frame = self.frame;
    frame.origin = CGPointMake(self.superview.frame.size.width + rightTop.x - frame.size.width, rightTop.y);
    self.frame = frame;
}

- (CGPoint)mcRightBottom {
    NSAssert(self.superview, @"need a superview!");
    CGRect frame = self.frame;
    return CGPointMake(frame.origin.x + frame.size.width - self.superview.frame.size.width, self.superview.frame.size.height - frame.origin.y - frame.size.height);
}

- (void)setMcRightBottom:(CGPoint)rightBottom {
    NSAssert(self.superview, @"need a superview!");
    CGRect frame = self.frame;
    frame.origin = CGPointMake(self.superview.frame.size.width + rightBottom.x - frame.size.width, self.superview.frame.size.height + rightBottom.y - frame.size.height);
    self.frame = frame;
}

@end
