//
//  ProtoConfGroup.swift
//  
//
//  Created by Rake Yang on 2021/6/18.
//

import Foundation

public enum ConfType: Int, Codable {
    case test = 0
    case dev = 1
    case production = 2
    
    public var description: String {
        switch self {
        case .test:
            return "测试"
        case .dev:
            return "开发"
        case .production:
            return "生产"
        }
    }
}

public struct ProtoConfGroup: Codable {
    public var type: ConfType = .test
    public var name: String = ConfType.test.description
    public var items: [ProtoConf] = []
    
    public init(_ type: ConfType) {
        self.type = type
        self.name = type.description
    }
}
