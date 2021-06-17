//
//  WebSocketController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import Networking
import PerfectHTTP
import PerfectLib
import PerfectWebSockets
import Rainbow
import CanaryProto

class WebSocketController {
    static var clients: [String : DTSHandler] = [:]

    @Mapping(path: "/channel/{platform}/{deviceid}")
    var handshake: ResultHandler = { request, response in
        if let secret = request.header(.custom(name: "app-secret")) {
            WebSocketHandler { req, protocols in
                var handler = DTSHandler()
                clients[req.urlVariables["deviceid"] ?? ""] = handler
                return handler
            }.handleRequest(request: request, response: response)
        } else {
            // 路径错误
            response.completed(status: .forbidden)
        }
        return nil
    }
        
    class DTSHandler: WebSocketSessionHandler {
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
                        WebSocketController.clients.removeValue(forKey: device.deviceId)
                        print("设备离线: \(device.deviceId), 共计【\(WebSocketController.clients.count)】在线".cyan)
                    }
                    self.socket?.close()
                    self.socket = nil
                } else {
                    do {
                        let msg = try JSONDecoder().decode(ProtoMessage.self, from: Data(data ?? []))
                        switch msg.type {
                        case .connected:
                            break
                        case .update:
                            break
                        case .register:
                            let isNew = self.device == nil
                            self.device = try? JSONDecoder().decode(ProtoDevice.self, from: msg.data?.rawData() ?? Data())
                            if let device = self.device {
                                WebSocketController.clients[device.deviceId] = self
                                print("设备\(isNew ? "连接":"更新"): \(device.deviceId), 共计【\(WebSocketController.clients.count)】在线".cyan)
                            }
                        case .list:
                            break
                        case .log:
                            break
                        }
                    } catch {
                        print("\(optype) \(error)".red)
                    }
                    
                    self.handleMessage()
                }
            })
        }
    }
}
