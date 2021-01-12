//
//  WebSocketMessage.swift
//  Canary
//
//  Created by Rake Yang on 2017/11/26.
//  Copyright © 2019 BinaryParadise. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MessageType: Int, Codable {
    /// 数据需要更新
    case update = 2
    /// 注册设备信息
    case registerDevice = 10
    //数据库查询请求
    case dbQuery    = 20
    /// 数据库查询结果
    case dbResult   = 21
    /// 本地日志
    case ttyLogger  = 30
    /// 网络日志
    case netLogger  = 31
};

class WebSocketMessage: Codable {
    var type: MessageType
    /**
     0: 成功
     -1: 失败
     >0: 业务代码
     */
    var code: Int
    var msg: String?
    var data: JSON?
    var appKey: String?

    /**
     是否已处理，默认为NO
     */
    var processed: Bool?
    
    init(type: MessageType) {
        code = 0
        appKey = CanarySwift.shared.appSecret
        self.type = type
    }
}

class DeviceMessage: Codable {
    var name: String?
    var deviceId: String?
    var ipAddrs: [String: [String:String]]?
    var appKey: String?
    var appVersion: String?
    var osName: String?
    var osVersion: String?
    var modelName: String?
    var profile: [String : JSON]?
    var simulator: Bool
    
    init() {
        name = UIDevice.current.name
        osName = UIDevice.current.systemName
        osVersion = UIDevice.current.systemVersion
        modelName = UIDevice.current.localizedModel
        appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        simulator = TARGET_OS_SIMULATOR == 1
        ipAddrs = ipAddress()
    }
    
    private func ipAddress() -> [String : [String : String]]? {
        var ipv4: [String : String] = [:]
        var ipv6: [String : String] = [:]
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                let name = String(cString: ptr!.pointee.ifa_name)
                                if name.hasPrefix("en") {
                                    if addr.sa_family == AF_INET {
                                        ipv4[name] = address
                                    } else {
                                        ipv6[name] = address
                                    }
                                }
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        
        return ["ipv4": ipv4, "ipv6" : ipv6]
    }
}
