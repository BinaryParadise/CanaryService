//
//  MCFrontendLogFormatter.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/26.
//

#import "MCFrontendLogFormatter.h"

@implementation MCFrontendLogFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)dateFormat:(NSDate *)date {
    NSDateFormatter *dateFmt = [NSDateFormatter new];
    dateFmt.dateFormat = @"MM-dd HH:mm:ss.SSS";
    return [dateFmt stringFromDate:date];
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    return [NSString stringWithFormat:@"%@+%ld %@", logMessage.function, logMessage.line, logMessage.message];
}

@end
