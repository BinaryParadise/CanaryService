//
//  ServerArgument.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/9.
//

import ArgumentParser
import Networking
import PerfectHTTP
import Foundation

var conf = ServerConfig(name: "127.0.0.1", port: 9001, path: "", sqlite: "./canary.db")

struct ServerArgument: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "配置文件路径")
    var config: String
    
    func run() throws {
        
        if FileManager.default.fileExists(atPath: config) {
            do {
                conf = try JSONDecoder().decode(ServerConfig.self, from: Data(contentsOf: URL(fileURLWithPath: config)))
            } catch {
                print("\(error)".red)
            }
            
            routes = Routes(baseUri: conf.path ?? "", handler: { request, response in
                response.setHeader(.server, value: "Canary/Perfect1.0")
                response.next()
            })
        } else {
            print("config file `\(config)` not found".red)
            Thread.exit()
        }
    }
}
