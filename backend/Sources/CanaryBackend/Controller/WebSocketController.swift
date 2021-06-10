//
//  WebSocketController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import Networking
import PerfectHTTP
import PerfectWebSockets

class WebSocketController {
    @Mapping(path: "/channel/{platform}/{deviceid}")
    var handshake: RequestHandler = { request, response in
        if let deviceid = request.urlVariables["deviceid"] {
            WebSocketHandler { req, protocols in
                if protocols.contains("dts") {
                    return DTSHandler()
                }
                return nil
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
                socket.readBytesMessage { data, optype, ret in
                    
                }
            }
            //handleMessage()
        }
        
        func handleMessage() {
            _socket?.readStringMessage { [weak self] str, type, ret in
                print("\(#function) -> \(str ?? "")")
                if type == .close || type == .invalid {
                    self?._socket?.close()
                    self?._socket = nil
                } else {
                    self?.handleMessage()
                }
            }
        }
    }
}
