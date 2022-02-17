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

var mgr = ClientSessionManager()
let AppSecretKey = "Canary-App-Secret"

class WebSocketController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("channel", ":platform", ":deviceid", maxFrameSize: WebSocketMaxFrameSize(integerLiteral: 1 << 16), onUpgrade: onUpgrade)
        routes.get("device", use: deviceList)
    }
    
    func onUpgrade(request: Request, webSocket: WebSocket) {
        let deviceId = request.parameters.get("deviceid") ?? ""
        if let _ = request.headers.first(name: AppSecretKey) {
            let handler = DTSClientHandler()
            mgr.add(deviceId: deviceId, session: handler)
            handler.handleSession(request: request, socket: webSocket)
        } else {
            if let device = mgr.getSession(deviceId: deviceId) {
                let handler = DTSWebHandler(deviceId: deviceId)
                device.observe[handler.identify] = handler
                handler.handleSession(request: request, socket: webSocket)
            } else {
                _ = webSocket.close(code: .unknown(1012))
            }
        }
        do {
            mgr.unlock()
        }
    }
    
    func deviceList(request: Request) throws -> Response {
        let devices = mgr.allDevices()
        defer {
            mgr.unlock()
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
            appSecret = request.headers.first(name: AppSecretKey)
            LogInfo("handshake: \(appSecret ?? "")")
            socket.onBinary(handleMessage)
            socket.onPing { ws in
                ws.send(raw: 1.encodedData() ?? Data(), opcode: .pong)
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                socket.send(raw: ProtoMessage(type: .connected, msg: "设备连接成功.").encodedData()!, opcode: .binary)
            }
            socket.onClose.whenComplete { r in                
                if let device = self.device {
                    let client = mgr.removeSession(deviceId: device.deviceId)
                    mgr.unlock()
                    client?.observe.forEach({ (key: String, value: DTSWebHandler) in
                        _ = value.socket?.close(code: .goingAway)
                    })
                    LogInfo("设备离线: \(device.deviceId)【\(mgr.count)】在线")
                    self.socket = nil
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
                        mgr.add(deviceId: device.deviceId, session: self)
                        mgr.unlock()
                        self.device?.update = Date().timeIntervalSince1970 * 1000
                        LogDebug("设备\(isNew ? "连接":"更新"): \(device.deviceId), 【\(mgr.count)】在线")
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
                LogError("\(error) \(data.hexEncodedString(uppercase: true))")
            }
        }
    }
    
    func forwardLog(data: [UInt8]) {
        if let client = mgr.getSession(deviceId: device?.deviceId ?? "") {
            client.observe.forEach { (key: String, value: DTSWebHandler) in
                LogDebug("消息转发到: \(value.identify)")
                value.socket?.send(raw: data, opcode: .binary)
            }
        }
        do {
            mgr.unlock()
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
            socket.onPing { ws in
                LogInfo("")
            }
            socket.onClose.whenComplete { r in
                mgr.getSession(deviceId: self.deviceId)?.observe.removeValue(forKey: self.identify)
                mgr.unlock()
                LogInfo("Web离线: \(self.deviceId)")
            }
        }
    }
    
    func handleMessage(webSocket: WebSocket, buffer: ByteBuffer) {
        var n = buffer
        if let d = n.readData(length: n.readableBytes), let str = String(data: d, encoding: .utf8) {
            let msg = ProtoMessage(type: .connected, msg: "设备连接成功!")
            webSocket.send(raw: msg.encodedData()!, opcode: .binary)
            LogWarn("来自Web监听消息: \(str)")
        }
    }
}

/// 客户端会话管理，保证线程安全
class ClientSessionManager {
    private var clients: [String : DTSClientHandler] = [:]
    private var _lock: NSLock = NSLock();
    var count: Int {
        _lock.lock()
        defer { _lock.unlock()}
        return clients.count
    }
    
    func add(deviceId: String, session: DTSClientHandler) {
        _lock.lock()
        clients[deviceId] = session
    }
    
    func getSession(deviceId: String) -> DTSClientHandler? {
        _lock.lock()
        return clients[deviceId]
    }
    
    func allDevices() -> [ProtoDevice] {
        _lock.lock()
        let devices = clients.values.compactMap { handler in
            handler.device
        }
        return devices
    }
    
    func removeSession(deviceId: String) -> DTSClientHandler? {
        _lock.lock()
        return clients.removeValue(forKey: deviceId)
    }
    
    func unlock() {
        _lock.unlock()
    }
}
