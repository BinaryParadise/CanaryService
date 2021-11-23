//
//  ServerConfig.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation

struct ServerConfig: Codable {
    /// localhost
    var name: String
    /// 9001
    var port: Int
    /// /api
    var path: String?
    /// ./canary.sqlite
    var sqlite: String
}
