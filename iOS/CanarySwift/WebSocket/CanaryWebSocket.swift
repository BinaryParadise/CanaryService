//
//  CanaryWebSocket.swift
//  Canary
//
//  Created by Rake Yang on 2020/12/11.
//

import Foundation
import Starscream
import SwiftyJSON

protocol WebSocketMessageProtocol: NSObjectProtocol {
    func webSocket(webSocket: CanaryWebSocket, didReceive message: WebSocketMessage)

    func webSocketDidOpen(webSocket: CanaryWebSocket);

    func webSocket(webSocket: CanaryWebSocket, didReceive pongPayload: Data?)
}

class CanaryWebSocket: NSObject {
    var mySocket: WebSocket?
    var webSocketURL: String = ""
    static var shared = CanaryWebSocket()
    
    private var retry = true
    private let retryInterval:TimeInterval = 10
    private var recivers: [WebSocketMessageProtocol] = []
    private var pingTimer: Timer?
    
    private var open = false
    func isReady() -> Bool {
        return open
    }
    
    func start() {
        mySocket?.disconnect()
        let fullURL = URL(string: "\(webSocketURL)/\(UIDevice.current.systemName)/\(CanarySwift.shared.deviceId!)")
        mySocket = WebSocket(request: URLRequest(url: fullURL!))
        mySocket?.delegate = self
        
        if pingTimer == nil {
            pingTimer = Timer.scheduledTimer(timeInterval: retryInterval, target: self, selector: #selector(pingAction), userInfo: nil, repeats: true)
            RunLoop.main.add(pingTimer!, forMode: .default)
        }
        pingTimer?.fire()
        mySocket?.connect()
    }
    
    func stop() {
        pingTimer?.invalidate()
        mySocket?.disconnect()
    }

    func addMessageReciver(reciver: WebSocketMessageProtocol) {
        let has = recivers.contains { (msg) -> Bool in
            return msg.hash == reciver.hash
        }
        if !has {
            recivers.append(reciver)
        }
    }

    func sendMessage(message: WebSocketMessage) {
        if isReady() {
            do {
                let data = try JSONEncoder().encode(message)
                mySocket?.write(data: data)
            } catch {
                print("\(#filePath).\(#function)+\(#line) \(error)")
            }
        }
    }
    
    @objc private func pingAction() {
        if(isReady()) {
            let t = Date().timeIntervalSince1970 * 1000
            mySocket?.write(ping: t.string.data(using: .utf8)!)
        }else {
            if (retry) {
                print("🍺 \(retryInterval)秒后重试连接");
                retry = false
                DispatchQueue.global().asyncAfter(deadline: .now()+retryInterval) { [weak self] in
                    self?.start()
                    self?.retry = true
                }
            }
        }
    }
}

extension CanaryWebSocket: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        
        case .connected(_):
            open = true
            recivers.forEach { (receiver) in
                receiver.webSocketDidOpen(webSocket: self)
            }
            print("🍺 WebSocket连接成功：\(client.request.url?.absoluteString ?? "")")
        case .disconnected(let reason, let code):
            open = false
            print("🍺 连接关闭：\(code)-\(reason)")
        case .text(_):
            break
        case .binary(let data):
            webSocket(client, didReceiveBinary: data)
        case .pong(let pongPayload):
            recivers.forEach { (receiver) in
                receiver.webSocket(webSocket: self, didReceive: pongPayload)
            }
        case .ping(_):
            break
        case .error(let error):
            print("❌ \(client.request.url?.absoluteString ?? "") \(error!)")
            if let error = error as NSError? {
                if error.code == 2133 || error.code == -72000 {
                    var components = URLComponents(string: webSocketURL)!
                    components.scheme = "wss"
                    webSocketURL = components.url?.absoluteString ?? ""
                }
            }
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break
        }
    }
    
    func webSocket(_ webSocket: WebSocket, didReceiveBinary data: Data) {
        do {
            let result = try JSONDecoder().decode(WebSocketMessage.self, from: data)
            if result.code == 0 {
                recivers.forEach { (receiver) in
                    receiver.webSocket(webSocket: self, didReceive: result)
                }
            } else {
                print("\(result.msg ?? "")")
            }
        } catch {
            print("\(#filePath).\(#function)+\(#line)\(error)")
        }
    }
}
