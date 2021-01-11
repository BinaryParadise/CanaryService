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
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"获取配置参数：A = %@", [CanarySwift.shared stringValueFor:@"A" def:@"123"]);
    
    self.textView = [[UITextView alloc] init];
    self.textView.editable = false;
    self.textView.textColor = UIColor.purpleColor;
    self.textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.5);
    }];
}

- (IBAction)showCanary:(id)sender {
    [CanarySwift.shared show];
    DDLogVerbose(@"verbose");
    DDLogInfo(@"info");
    DDLogWarn(@"warn");
    DDLogDebug(@"debug");
    DDLogError(@"error");
}

- (IBAction)showNetworking:(id)sender {
    
//    NSLog(@"%@", NSURLSessionConfiguration.defaultSessionConfiguration.protocolClasses);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    manager.requestSerializer = AFHTTPRequestSerializer.serializer;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
    NSURLSessionDataTask *task = [manager GET:@"https://api.m.taobao.com/rest/api3.do?api=mtop.common.getTimestamp" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self showJSONObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    [task resume];
    
}

- (void)showJSONObject:(id)jsonObject {
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted|NSJSONWritingFragmentsAllowed error:nil];
    self.textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (IBAction)showNetworkingParam:(id)sender {
//    NSLog(@"%@", NSURLSessionConfiguration.defaultSessionConfiguration.protocolClasses);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    manager.requestSerializer = AFHTTPRequestSerializer.serializer;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
    NSURLSessionDataTask *task = [manager GET:@"http://quan.suning.com/getSysTime.do" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self showJSONObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    [task resume];
}


@end
