//
//  ProtoConfItem.swift
//  
//
//  Created by Rake Yang on 2021/6/18.
//

import Foundation

public struct ProtoConfItem: Codable {
    public var id: Int
    public var name:String
    public var value:String
    public var envid: Int
    public var updateTime: Int64
    public var comment: String?
    public var uid: Int
    public var author: String?
}
