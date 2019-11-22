# 如何使用

安装依赖

```bash
npm install
```

启动服务
```bash
npm start
```

继承到你的项目中

```objc

pod 'MCLogger', '~> 0.5'

#import <MCLogger/MCLogger.h>

[DDLog addLogger:[DDTTYLogger sharedInstance]];
[MCLogger startMonitor:[NSURL URLWithString:@"ws://127.0.0.1:8081"]]
```


## [预览](http://127.0.0.1:8000)

![image](https://user-images.githubusercontent.com/8289395/58154303-e4b39a80-7ca3-11e9-80ca-b8e0af1b0ec8.png)
