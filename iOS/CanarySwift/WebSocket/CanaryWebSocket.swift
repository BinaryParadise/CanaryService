//
//  CanaryWebSocket.swift
//  Canary
//
//  Created by Rake Yang on 2020/12/11.
//

import Foundation
import SocketRocket
import SwiftyJSON

protocol WebSocketMessageProtocol: NSObjectProtocol {
    func webSocket(webSocket: CanaryWebSocket, didReceive message: WebSocketMessage)

    func webSocketDidOpen(webSocket: CanaryWebSocket);

    func webSocket(webSocket: CanaryWebSocket, didReceive pongPayload: Data?)
}

class CanaryWebSocket: NSObject {
    var mySocket = SRWebSocket()
    var webSocketURL: String = ""
    static var shared = CanaryWebSocket()
    
    private var retry = true
    private let retryInterval:TimeInterval = 10
    private var recivers: [WebSocketMessageProtocol] = []
    private var pingTimer: Timer?
    
    func isReady() -> Bool {
        return mySocket.readyState == .OPEN
    }
    
    func start() {
        if isReady() {
            mySocket.close()
        }
        let fullURL = URL(string: "\(webSocketURL)/\(UIDevice.current.systemName)/\(CanarySwift.shared.deviceId!)")
        mySocket = SRWebSocket(url: fullURL!)
        mySocket.delegate = self
        
        if pingTimer == nil {
            pingTimer = Timer.scheduledTimer(timeInterval: retryInterval, target: self, selector: #selector(pingAction), userInfo: nil, repeats: true)
            RunLoop.main.add(pingTimer!, forMode: .default)
        }
        pingTimer?.fire()
        mySocket.open()
    }
    
    func stop() {
        pingTimer?.invalidate()
        mySocket.close()
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
                mySocket.send(data)
            } catch {
                print("\(#filePath).\(#function)+\(#line) \(error)")
            }
        }
    }
    
    @objc private func pingAction() {
        let state = mySocket.readyState
        if(state == .OPEN) {
            mySocket.sendPing(Date().timeIntervalSince1970.string.data(using: .utf8))
        }else {
            if (retry && (state == .CLOSED || state == .CLOSING)) {
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

extension CanaryWebSocket: SRWebSocketDelegate {
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        recivers.forEach { (receiver) in
            receiver.webSocketDidOpen(webSocket: self)
        }
        print("🍺 WebSocket连接成功：\(webSocket.url)")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        do {
            let result = try JSONDecoder().decode(WebSocketMessage.self, from: message as? Data ?? Data())
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

    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        recivers.forEach { (receiver) in
            receiver.webSocket(webSocket: self, didReceive: pongPayload)
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("❌ \(webSocket.url!) \(error!)")
        if let error = error as NSError? {
            if error.code == 2133 || error.code == -72000 {
                var components = URLComponents(string: webSocketURL)!
                components.scheme = "wss"
                webSocketURL = components.url?.absoluteString ?? ""
            }
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("🍺 连接关闭：\(code)-\(reason ?? "")")
    }
}
