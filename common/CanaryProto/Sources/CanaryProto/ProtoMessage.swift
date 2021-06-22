//
//  ProtoMessage.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import SwiftyJSON

public enum Action: Int, Codable {
    /// 连接成功
    case connected = 1
    /// 更新
    case update = 2
    /// 注册设备
    case register = 10
    /// 设备列表
    case list = 11
    /// 日志
    case log = 30
}

public struct ProtoMessage: Codable {
    public var code: Int?
    public var data: JSON?
    public var message: String?
    public var type: Action
    
    public init(type: Action) {
        self.code = 0
        self.type = type
    }
}
