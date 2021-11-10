//
//  WebSocketController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import PerfectHTTP
import PerfectLib
import PerfectWebSockets
import Proto
import SwiftyJSON

/// 设备列表
var clients: [String : DTSClientHandler] = [:]
var webSessions: [String: [DTSWebHandler]] = [:]

class WebSocketController {

    @Mapping(path: "/channel/{platform}/{deviceid}")
    var handshake: ResultHandler = { request, response in
        WebSocketHandler { req, protocols in
            let deviceId = req.urlVariables["deviceid"] ?? ""
            if let secret = request.header(.custom(name: "app-secret")) {
                var handler = DTSClientHandler()
                clients[deviceId] = handler
                return handler
            } else {
                var handler = DTSWebHandler(deviceId: deviceId)
                if webSessions.contains(where: { key, value in
                    key == deviceId
                }) {
                    var sessions = webSessions[deviceId]!
                    sessions.append(handler)
                } else {
                    webSessions[deviceId] = [handler]
                }
                return handler
            }
        }.handleRequest(request: request, response: response)
        return nil
    }
    
    @Mapping(path: "/device")
    var deviceList: ResultHandler = { request, response in
        let devices = clients.values.compactMap { handler in
            handler.device
        }
        return .entry(try JSONEncoder().encode(devices))
    }
}

class DTSClientHandler: WebSocketSessionHandler {
    var socketProtocol: String?
    var socket: WebSocket?
    var appSecret: String?
    var device: ProtoDevice?
    
    func handleSession(request req: HTTPRequest, socket: WebSocket) {
        self.socket = socket
        if socket.isConnected {
            appSecret = req.header(.custom(name: "app-secret"))
            LogInfo("handshake: \(appSecret ?? "")")
            handleMessage()
        }
    }
    
    func handleMessage() {
        self.socket?.readBytesMessage(continuation: { [weak self] data, optype, ret in
            guard let self = self else { return }
            if optype == .close || optype == .invalid {
                if let device = self.device {
                    clients.removeValue(forKey: device.deviceId)
                    LogInfo("设备离线: \(device.deviceId)【\(clients.count)】在线")
                }
                self.socket?.close()
                self.socket = nil
            } else {
                if let data = data {
                    do {
                        let msg = try JSONDecoder().decode(ProtoMessage.self, from: Data(data))
                        switch msg.type {
                        case .connected:
                            break
                        case .update:
                            break
                        case .register:
                            let isNew = self.device == nil
                            self.device = try? JSONDecoder().decode(ProtoDevice.self, from: msg.data?.rawData() ?? Data())
                            if let device = self.device {
                                clients[device.deviceId] = self
                                LogInfo("设备\(isNew ? "连接":"更新"): \(device.deviceId), 【\(clients.count)】在线")
                            }
                        case .log:
                            DispatchQueue.global().async {
                                self.forwardLog(data: data)
                            }
                            break
                        default:
                            break
                        }
                    } catch {
                        LogError("\(optype) \(error)")
                    }
                }
                
                self.handleMessage()
            }
        })
    }
    
    func forwardLog(data: [UInt8]) {
        guard let sessions = webSessions[device?.deviceId ?? ""] else { return }
        sessions.forEach { web in
            web.socket?.sendBinaryMessage(bytes: data, final: true, completion: {
                
            })
        }
    }
}

class DTSWebHandler: WebSocketSessionHandler {
    var deviceId: String
    var socketProtocol: String?
    var socket: WebSocket?
    
    init(deviceId: String) {
        self.deviceId = deviceId
    }
    
    func handleSession(request req: HTTPRequest, socket: WebSocket) {
        self.socket = socket
        if socket.isConnected {
            LogInfo("Web监听设备: \(deviceId)")
            do {
                handleMessage()
            } catch {
                LogError("\(error)")
            }
        }
    }
    
    func handleMessage() {
        self.socket?.readBytesMessage(continuation: { [weak self] data, optype, ret in
            guard let self = self else { return }
            if optype == .close || optype == .invalid {
                self.socket?.close()
                self.socket = nil
                webSessions.removeValue(forKey: self.deviceId)
                var count = 0
                webSessions.forEach { key, value in
                    count += value.count
                }
                LogWarn("Web端离线: \(self.deviceId), 【\(count)】在线")
            } else {
                self.handleMessage()
            }
        })
    }
}
