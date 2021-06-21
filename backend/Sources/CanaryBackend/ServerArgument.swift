//
//  ServerArgument.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/9.
//

import ArgumentParser
import PerfectHTTP
import Foundation

let folder = "/usr/local/etc/canary"
var conf = ServerConfig(name: "127.0.0.1", port: 9001, path: "/api", sqlite: "db/canary.db")

struct ServerArgument: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "配置文件路径")
    var config: String?
    
    func run() throws {
        if let config = config, FileManager.default.fileExists(atPath: "\(folder)/\(config)") {
            do {
                conf = try JSONDecoder().decode(ServerConfig.self, from: Data(contentsOf: URL(fileURLWithPath: config)))
            } catch {
                print("\(error)".red)
            }
            
            
        } else {
            print("Have none config file, use default.".yellow)
        }
        
        baseUri = conf.path ?? ""
        
        let _ = try? FileManager.default.createDirectory(at: URL(fileURLWithPath: "\(folder)/\(conf.sqlite)".deletingLastFilePathComponent), withIntermediateDirectories: true, attributes: nil)
        routes = Routes(baseUri: conf.path ?? "", handler: { request, response in
            response.setHeader(.server, value: "Canary/Perfect1.0")
            response.next()
        })
    }
}
