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
import SwiftyJSON

struct DTSDevice: Codable {
    var ipAddrs: JSON?
    var simulator: Bool
    var appVersion: String
    var osName: String
    var osVersion: String
    var modelName: String
    var name: String
    var profile: JSON?
}

struct DTSMessage: Codable {
    var code: Int
    var data: JSON?
    var message: String?
    var type: Action
    
    enum Action: Int, Codable {
        case device = 10
    }
}

class WebSocketController {
    @Mapping(path: "/channel/{platform}/{deviceid}")
    var handshake: RequestHandler = { request, response in
        if let deviceid = request.urlVariables["deviceid"] {
            WebSocketHandler { req, protocols in
                return DTSHandler()
            }.handleRequest(request: request, response: response)
        } else {
            // 路径错误
            response.completed(status: .forbidden)
        }
    }
        
    class DTSHandler: WebSocketSessionHandler {
        var socketProtocol: String?
        var _socket: WebSocket?
        var appSecret: String?
        
        func handleSession(request req: HTTPRequest, socket: WebSocket) {
            print("handshake: \(socket)")
            _socket = socket
            if socket.isConnected {
                appSecret = req.header(.custom(name: "app-secret"))
                handleMessage()
            }
        }
        
        func handleMessage() {
            _socket?.readBytesMessage(continuation: { [weak self] data, optype, ret in
                do {
                    let msg = try JSONDecoder().decode(DTSMessage.self, from: Data(data ?? []))
                } catch {
                    print("\(error)".red)
                }
                if optype == .close || optype == .invalid {
                    self?._socket?.close()
                    self?._socket = nil
                } else {
                    self?.handleMessage()
                }
            })
        }
    }
}
