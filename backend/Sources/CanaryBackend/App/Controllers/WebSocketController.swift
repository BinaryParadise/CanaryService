//
//  WebSocketController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import Proto
import SwiftyJSON
import Vapor

/// 设备列表
var clients: [String : DTSClientHandler] = [:]
var webSessions: [String: [DTSWebHandler]] = [:]

class WebSocketController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("channel", ":platform", ":deviceid", onUpgrade: onUpgrade)
        routes.get("device", use: deviceList)
    }
    
    func onUpgrade(request: Request, webSocket: WebSocket) {
        let deviceId = request.parameters.get("deviceid") ?? ""
        if let _ = request.headers.first(name: "app-secret") {
            let handler = DTSClientHandler()
            clients[deviceId] = handler
            handler.handleSession(request: request, socket: webSocket)
        } else {
            let handler = DTSWebHandler(deviceId: deviceId)
            if webSessions.contains(where: { key, value in
                key == deviceId
            }) {
                var sessions = webSessions[deviceId]!
                sessions.append(handler)
            } else {
                webSessions[deviceId] = [handler]
            }
            handler.handleSession(request: request, socket: webSocket)
        }
    }
    
    func deviceList(request: Request) throws -> Response {
        let devices = clients.values.compactMap { handler in
            handler.device
        }
        return .success(try JSONEncoder().encode(devices))
    }
}

class DTSClientHandler {
    var socketProtocol: String?
    var socket: WebSocket?
    var appSecret: String?
    var device: ProtoDevice?
    
    func handleSession(request: Request, socket: WebSocket) {
        self.socket = socket
        if !socket.isClosed {
            appSecret = request.headers.first(name: "app-secret")
            LogInfo("handshake: \(appSecret ?? "")")
            socket.onBinary(handleMessage)
            //TODO: socket.onClose
//            if let device = self.device {
//                clients.removeValue(forKey: device.deviceId)
//                LogInfo("设备离线: \(device.deviceId)【\(clients.count)】在线")
//            }
//            self.socket?.close()
//            self.socket = nil
        }
    }
    
    func handleMessage(webSocket: WebSocket, buffer: ByteBuffer) {
        var n = buffer
        if let data = n.readData(length: buffer.readableBytes) {
            do {
                let msg = try JSONDecoder().decode(ProtoMessage.self, from: Data(data))
                switch msg.type {
                case .connected:
                    break
                case .update:
                    break
                case .register:
                    let isNew = self.device == nil
                    self.device = try JSONDecoder().decode(ProtoDevice.self, from: msg.data?.rawData() ?? Data())
                    if let device = self.device {
                        clients[device.deviceId] = self
                        LogInfo("设备\(isNew ? "连接":"更新"): \(device.deviceId), 【\(clients.count)】在线")
                    }
                case .log:
                    DispatchQueue.global().async {
                        self.forwardLog(data: [UInt8](data))
                    }
                    break
                default:
                    break
                }
            } catch {
                LogError("\(error)")
            }
        }
    }
    
    func forwardLog(data: [UInt8]) {
        guard let sessions = webSessions[device?.deviceId ?? ""] else { return }
        sessions.forEach { web in
            web.socket?.send(raw: data, opcode: .binary)
        }
    }
}

class DTSWebHandler {
    var deviceId: String
    var socketProtocol: String?
    var socket: WebSocket?
    
    init(deviceId: String) {
        self.deviceId = deviceId
    }
    
    func handleSession(request: Request, socket: WebSocket) {
        self.socket = socket
        if !socket.isClosed {
            LogInfo("Web监听设备: \(deviceId)")
            socket.onBinary(handleMessage)
        }
    }
    
    func handleMessage(webSocket: WebSocket, buffer: ByteBuffer) {
        var n = buffer
        if let data = n.readData(length: n.readableBytes) {
            if webSocket.isClosed {
                try? self.socket?.close(code: .normalClosure).wait()
                self.socket = nil
                webSessions.removeValue(forKey: self.deviceId)
                var count = 0
                webSessions.forEach { key, value in
                    count += value.count
                }
                LogWarn("Web端离线: \(self.deviceId), 【\(count)】在线")
            }
        }
    }
}
