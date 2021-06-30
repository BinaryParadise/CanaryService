//
//  ProtoUser.swift
//  
//
//  Created by Rake Yang on 2021/6/17.
//

import Foundation

public struct ProtoUser: Codable {
    public var id: Int = 0
    public var username: String = ""
    public var password: String?
    public var name: String
    public var token: String?
    public var roleid: Int = 3
    public var rolename: String?
    public var rolelevel: Int?
    public var expire: Int64?
    public var app: ProtoProject?
    public var app_id: Int?
    
    public init() {
        self.name = ""
    }
    
    public var invalid: Bool {
        return expire ?? 0 <= Int64(Date().timeIntervalSince1970 * 1000)
    }
}
