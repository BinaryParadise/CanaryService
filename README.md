# How to use

install dependency

```ruby
npm install
```

start serve
```ruby
npm start
```

import to you project

```objc

pod 'MCLogger', '~> 0.5'

#import <MCLogger/MCLogger.h>

[DDLog addLogger:[DDTTYLogger sharedInstance]];
[MCLogger startMonitor:[NSURL URLWithString:@"ws://127.0.0.1:8081"]]
```


## Preview

![image](https://user-images.githubusercontent.com/8289395/58154303-e4b39a80-7ca3-11e9-80ca-b8e0af1b0ec8.png)
