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

struct DTSMessage: Codable {
    var code: Int
    var data: Dictionary<String, AnyObject>
    var message: String?
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
        
        func handleSession(request req: HTTPRequest, socket: WebSocket) {
            print("handshake: \(socket)")
            _socket = socket
            if socket.isConnected {
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
