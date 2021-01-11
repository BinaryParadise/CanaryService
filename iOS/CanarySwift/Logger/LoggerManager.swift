//
//  TTYLoggerAdapter.swift
//  Canary
//
//  Created by Rake Yang on 2017/12/16.
//  Copyright © 2017年 BinaryParadise. All rights reserved.
//

import Foundation
import SwifterSwift
import SwiftyJSON

class LoggerManager: NSObject {
    var customProfile: (() -> [String: Any])?
    static let shared = LoggerManager()
    var updateTime = Date().timeIntervalSince1970
    
    func start(with domain: URL) -> Void {
        CanaryWebSocket.shared.webSocketURL = domain.absoluteString
        CanaryWebSocket.shared.addMessageReciver(reciver: self)
        CanaryWebSocket.shared.start()
    }
    
    func addTTYLogger(dict:[String : Any], timestamp: TimeInterval) -> Void {
        if CanaryWebSocket.shared.isReady() {
            let message = WebSocketMessage(type: .ttyLogger)
            var mdict = dict
            mdict["appVersion"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
            mdict["timestamp"] = timestamp*1000
            mdict["deviceId"] = CanarySwift.shared.deviceId;
            mdict["type"] = 1;
            message.data = JSON(mdict)
            CanaryWebSocket.shared.sendMessage(message: message)
        }
    }
    
    func register(webSocket: CanaryWebSocket) {
        let msg = WebSocketMessage(type: .registerDevice)
        let device = DeviceMessage()
        device.deviceId = CanarySwift.shared.deviceId
        device.appKey = CanarySwift.shared.appSecret;
        var dict: [String : JSON] = [:]
        customProfile?().forEach({ (key, value) in
            dict[key] = JSON(value)
        })
        device.profile = dict
        do {
            msg.data = try JSON(JSONEncoder().encode(device))
        } catch {
            print("\(#filePath).\(#function)+\(#line) \(error)")
        }
        webSocket.sendMessage(message: msg)
    }
}

extension LoggerManager: WebSocketMessageProtocol {
    func webSocketDidOpen(webSocket: CanaryWebSocket) {
        register(webSocket: webSocket)
    }
    
    func webSocket(webSocket: CanaryWebSocket, didReceive message: WebSocketMessage) {
        
    }
    
    func webSocket(webSocket: CanaryWebSocket, didReceive pongPayload: Data?) {
        //更新设备信息
        register(webSocket: webSocket)
        guard let pongPayload = pongPayload else { return }
        if updateTime < pongPayload.string(encoding: .utf8)?.double() ?? 0 / 1000.0 {
            updateTime = Date().timeIntervalSince1970
            //更新Mock配置
            MockManager.shared.fetchGroups {
                
            }
        }
    }
}
