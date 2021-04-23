# iOS SDK 接入指南

> CANARY_ENABLE用于编译隔离

```swift
#if CANARY_ENABLE
import Canary
#endif

func config() {
    #if CANARY_ENABLE
        // Web端部署的域名
        shared.baseURL = "http://frontend.xinc818.com"
        // 应用授权码（添加应用后生成）
        shared.appSecret = "c8269eb66def959332fb0ddb1b5d4dc2"
        // 设备标识
        shared.deviceId = "7da5c360-a3fa-11eb-bcbc-0242ac130002"
        //添加自定义日志处理（上传日志到后端）
        DDLog.add(CanaryTTYLogger.shared);
        //启动日志监听
        shared.startLogger(domain: nil) { () -> [String : Any] in
            //自定义信息（设备信息中展示)
            var mdict: [String : Any] = [:]
            mdict["APNSToken"] = CloudPushSDK.getApnsDeviceToken()
            mdict["阿里云推送DeviceId"] = CloudPushSDK.getDeviceId()
            mdict["登录数据"] = UserDefaults.standard.dictionary(forKey: "VIP8.com_UserInfoDic")
            mdict["游客数据"] = UserDefaults.standard.dictionary(forKey: "VIP8.com_VisitorInfoDic")
            return mdict;
        }
    #endif
}
```

```swift
// 打开配置页面
CanarySwift.shared.show()
```

```swift
class CanaryTTYLogger: DDAbstractLogger {
    static let shared = CanaryTTYLogger()
    override func log(message logMessage: DDLogMessage) {
        #if CANARY_ENABLE
        CanarySwift.shared.storeLogMessage(dict: logMessage.dictionaryWithValues(forKeys: StoreLogKeys), timestamp: logMessage.timestamp.timeIntervalSince1970)
        #endif
    }
}
```
