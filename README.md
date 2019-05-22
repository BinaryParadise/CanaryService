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
