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

class WebSocketController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("channel", ":platform", ":deviceid", maxFrameSize: WebSocketMaxFrameSize(integerLiteral: 1 << 16), onUpgrade: onUpgrade)
        routes.get("device", use: deviceList)
    }
    
    func onUpgrade(request: Request, webSocket: WebSocket) {
        let deviceId = request.parameters.get("deviceid") ?? ""
        if let _ = request.headers.first(name: "app-secret") {
            let handler = DTSClientHandler()
            clients[deviceId] = handler
            handler.handleSession(request: request, socket: webSocket)
        } else {
            if let device = clients[deviceId] {
                let handler = DTSWebHandler(deviceId: deviceId)
                device.observe[handler.identify] = handler
                handler.handleSession(request: request, socket: webSocket)
            }
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
    var observe: [String : DTSWebHandler] = [:]
    
    func handleSession(request: Request, socket: WebSocket) {
        self.socket = socket
        if !socket.isClosed {
            appSecret = request.headers.first(name: "app-secret")
            LogInfo("handshake: \(appSecret ?? "")")
            socket.onBinary(handleMessage)
            socket.onClose.whenComplete { r in
                switch r {
                case .success():
                    if let device = self.device {
                        let client = clients.removeValue(forKey: device.deviceId)
                        client?.observe.forEach({ (key: String, value: DTSWebHandler) in
                            _ = value.socket?.close(code: .goingAway)
                        })
                        LogInfo("设备离线: \(device.deviceId)【\(clients.count)】在线")
                        self.socket = nil
                    }
                case .failure(_):
                    break
                }
            }
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
                        self.device?.update = Date().timeIntervalSince1970 * 1000
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
        guard let client = clients[device?.deviceId ?? ""] else { return }
        client.observe.forEach { (key: String, value: DTSWebHandler) in
            LogDebug("消息转发到: \(value.identify)")
            value.socket?.send(raw: data, opcode: .binary)
        }
    }
}

class DTSWebHandler {
    var deviceId: String
    var socketProtocol: String?
    var socket: WebSocket?
    var identify: String
    
    init(deviceId: String) {
        self.deviceId = deviceId
        identify = UUID().uuidString
    }
    
    func handleSession(request: Request, socket: WebSocket) {
        self.socket = socket
        if !socket.isClosed {
            LogInfo("Web监听设备: \(deviceId)")
            socket.onBinary(handleMessage)
            socket.onClose.whenComplete { r in
                clients[self.deviceId]?.observe.removeValue(forKey: self.identify)
                LogInfo("Web离线: \(self.deviceId)")
            }
        }
    }
    
    func handleMessage(webSocket: WebSocket, buffer: ByteBuffer) {
        var n = buffer
        if let d = n.readData(length: n.readableBytes), let str = String(data: d, encoding: .utf8) {
            //TODO: 读取数据
            LogInfo("来自Web监听消息: \(str)")
        }
    }
}
