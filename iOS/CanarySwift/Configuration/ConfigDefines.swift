//
//  ConfigDefines.swift
//  Canary
//
//  Created by Rake Yang on 2020/12/11.
//

import Foundation

class ConfigGroup: Codable {
    
    /// 分组类型
    var type: GroupType
    
    /// 名称
    var name: String
    
    /// 参数集合
    var items: [ConfigItem]
    
    enum GroupType: Int, Codable {
        case test = 0
        case dev = 1
        case product = 2
        
        init(from decoder: Decoder) throws {
            self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .test
        }
    }
}

class ConfigItem: Codable {
    var id: Int
    var name: String
    
    /// 描述
    var comment: String
    var subItems: [ConfigSubItem]?
    var defaultTag: Bool?
}

class ConfigSubItem: Codable {
    
    /// 参数名称
    var name: String
    
    /// 参数值
    var value: String?
    
    /// 描述
    var comment: String?
}
