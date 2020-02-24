//
//  MCDevice.m
//  MCLogger
//
//  Created by Rake Yang on 2020/2/19.
//

#import "MCDevice.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>

NSString * getIPAddress() {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
#if TARGET_OS_SIMULATOR
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] hasPrefix:@"en"]) {
#else
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
#endif
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    interfaces = NULL;
    
    return address;
}

@implementation MCDevice

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = UIDevice.currentDevice.name;
        self.ipAddr = getIPAddress();
        self.appVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
        self.osName = UIDevice.currentDevice.systemName;
        self.osVersion = UIDevice.currentDevice.systemVersion;
        self.modelName = UIDevice.currentDevice.localizedModel;
        self.simulator = TARGET_OS_SIMULATOR;
        self.profile = @{};
    }
    return self;
}

@end
