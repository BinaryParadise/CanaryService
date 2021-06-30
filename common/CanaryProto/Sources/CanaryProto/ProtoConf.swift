//
//  ProtoConf.swift
//  
//
//  Created by Rake Yang on 2021/6/18.
//

import Foundation

public struct ProtoConf: Codable {
    public var id: Int
    public var name: String
    public var type: ConfType
    public var updateTime: Int64
    public var appId: Int
    public var author: String?
    public var uid: Int
    public var comment: String?
    public var subItems: [ProtoConfItem]?
    @Default.False
    public var defaultTag: Bool
    public var copyid: Int?
}
