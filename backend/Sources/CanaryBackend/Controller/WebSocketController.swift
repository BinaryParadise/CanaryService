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
import Rainbow
import CanaryProto
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
            print("handshake: \(appSecret ?? "")")
            handleMessage()
        }
    }
    
    func handleMessage() {
        self.socket?.readBytesMessage(continuation: { [weak self] data, optype, ret in
            guard let self = self else { return }
            if optype == .close || optype == .invalid {
                if let device = self.device {
                    clients.removeValue(forKey: device.deviceId)
                    print("设备离线: \(device.deviceId), 共计【\(clients.count)】在线".cyan)
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
                                print("设备\(isNew ? "连接":"更新"): \(device.deviceId), 共计【\(clients.count)】在线".cyan)
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
                        print("\(optype) \(error)".red)
                    }
                }
                
                self.handleMessage()
            }
        })
    }
    
    func forwardLog(data: [UInt8]) {
        guard let sessions = webSessions[device?.deviceId ?? ""] else { return }
        print("转发日志".yellow)
        sessions.forEach { web in
            web.socket?.sendBinaryMessage(bytes: data, final: true, completion: {
                
            })
        }
    }
    
    deinit {
        print("\(#function)")
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
            print("Web开始监听设备: \(deviceId)")
            handleMessage()
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
                print("Web端离线: \(self.deviceId), 共计【\(count)】在线".cyan)
            } else {
                self.handleMessage()
            }
        })
    }
}
