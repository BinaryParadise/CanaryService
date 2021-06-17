//
//  ProtoUser.swift
//  
//
//  Created by Rake Yang on 2021/6/17.
//

import Foundation

public struct ProtoUser: Codable {
    public var id: Int
    public var username: String
    public var name: String
    public var token: String
    public var roleid: Int
    public var rolename: String
    public var rolelevel: Int
    public var expire: TimeInterval
    public var app: ProtoProject?
    
    public var invalid: Bool {
        return expire <= Date().timeIntervalSince1970 * 1000
    }
}
