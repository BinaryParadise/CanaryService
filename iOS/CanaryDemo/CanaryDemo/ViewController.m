//
//  ViewController.m
//  CanaryDemo
//
//  Created by Rake Yang on 2020/12/13.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "CanaryDemo-Bridging-Header.h"
#import "CanaryDemo-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"获取配置参数：A = %@", [CanarySwift.shared stringValueFor:@"A" def:@"123"]);
}

- (IBAction)showCanary:(id)sender {
    [CanarySwift.shared show];
    DDLogVerbose(@"verbose");
    DDLogInfo(@"info");
    DDLogWarn(@"warn");
    DDLogDebug(@"degbu");
    DDLogError(@"error");
}

- (IBAction)showNetworking:(id)sender {
    
    NSLog(@"%@", NSURLSessionConfiguration.defaultSessionConfiguration.protocolClasses);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    manager.requestSerializer = AFHTTPRequestSerializer.serializer;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
    NSURLSessionDataTask *task = [manager GET:@"https://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    [task resume];
    
}

- (IBAction)showNetworkingParam:(id)sender {
    NSLog(@"%@", NSURLSessionConfiguration.defaultSessionConfiguration.protocolClasses);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    manager.requestSerializer = AFHTTPRequestSerializer.serializer;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
    NSURLSessionDataTask *task = [manager GET:@"http://quan.suning.com/getSysTime.do" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    [task resume];
}


@end
