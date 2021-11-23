//
//  ServerArgument.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/9.
//

import ArgumentParser
import Foundation

#if os(Linux)
var conf = ServerConfig(name: "127.0.0.1", port: 9001, path: "/api", sqlite: "canary.db")
#else
var conf = ServerConfig(name: "127.0.0.1", port: 9001, path: "/api", sqlite: "/usr/local/etc/canary/db/canary.db")
#endif

struct ServerArgument: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "配置文件路径")
    var config: String?
    
    func run() throws {
        if let config = config, FileManager.default.fileExists(atPath: config) {
            do {
                conf = try JSONDecoder().decode(ServerConfig.self, from: Data(contentsOf: URL(fileURLWithPath: config)))
            } catch {
                LogError("\(error)")
            }
            
            
        } else {
            LogInfo("Have none config file, use default.")
        }
                
        let _ = try? FileManager.default.createDirectory(at: URL(fileURLWithPath: "\(conf.sqlite)").deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
    }
}
