# MCFrontendKit



## 安装

使用 [CocoaPods](https://cocoapods.org) 集成

```ruby
pod 'MCFrontendKit'
```



## 初始化

```objc
#import <MCFrontendKit/MCFrontendKit.h>

//【可选】设置项目的唯一标识（默认是CFBundleIdentifier）
MCFrontendKit.manager.appKey = @"com.binaryparadise.neverland";
//启用调试
MCFrontendKit.manager.enableDebug = YES;
//环境配置获取地址
MCFrontendKit.manager.baseURL = [NSURL URLWithString:@"http://127.0.0.1:9001/v2/conf/full"];
//【可选】额外扩展
[MCFrontendKit.manager startLogMonitor:^NSDictionary<NSString *,NSString *> *{
    return @{@"PushToken": @"fjejfliejglaje",
             @"uid": @"0101010101",
             @"num": @100982,
             @"dict": @{@"a":@"neverland", @"b":@"life", @"n": @1988788978639}
            };
}];
```

