//
//  ServerArgument.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/9.
//

import ArgumentParser
import Networking
import PerfectHTTP

var listenPort: Int = 8081
var listenAddr: String = "127.0.0.1"

struct ServerArgument: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "本地监听端口")
    var port: Int?
    
    @Option(name: .shortAndLong, help: "本地监听地址")
    var addr: String?
    
    @Option(name: .shortAndLong, help: "上下文路径")
    var contextPath: String?
    
    func run() throws {
        if let port = port {
            listenPort = port
        }
        if let addr = addr {
            listenAddr = addr
        }

        routes = Routes(baseUri: contextPath ?? "", handler: { request, response in
            response.setHeader(.server, value: "Canary/Perfect1.0")
            response.next()
        })
    }
}
