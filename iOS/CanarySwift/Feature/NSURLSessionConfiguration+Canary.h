//
//  NSURLSessionConfiguration+Canary.h
//  Canary
//
//  Created by Rake Yang on 2020/12/14.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionConfiguration (Canary)

@property (class, nonatomic, assign) Class customProtocolClass;

@end
