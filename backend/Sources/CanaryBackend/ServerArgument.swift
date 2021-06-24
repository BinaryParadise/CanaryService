//
//  ServerArgument.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/9.
//

import ArgumentParser
import PerfectHTTP
import Foundation
import PerfectLogger

#if os(Linux)
var conf = ServerConfig(name: "127.0.0.1", port: 9001, path: "/api", sqlite: "canary.db")
#else
var conf = ServerConfig(name: "127.0.0.1", port: 9001, path: "/api", sqlite: "/usr/local/etc/canary/db/canary.db")
#endif

struct ServerArgument: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "配置文件路径")
    var config: String?
    
    func run() throws {        
        LogFile.location = "/var/log/canary/log.log"
        LogFile.options = .none
        
        if let config = config, FileManager.default.fileExists(atPath: config) {
            do {
                conf = try JSONDecoder().decode(ServerConfig.self, from: Data(contentsOf: URL(fileURLWithPath: config)))
            } catch {
                LogError("\(error)".red)
            }
            
            
        } else {
            LogInfo("Have none config file, use default.".yellow)
        }
        
        baseUri = conf.path ?? ""
        
        let _ = try? FileManager.default.createDirectory(at: URL(fileURLWithPath: "\(conf.sqlite)".deletingLastFilePathComponent), withIntermediateDirectories: true, attributes: nil)
        routes = Routes(baseUri: conf.path ?? "", handler: { request, response in
            response.setHeader(.server, value: "Canary/Perfect1.0")
            response.next()
        })
    }
}
