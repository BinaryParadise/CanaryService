//
//  ProtoResult.swift
//  
//
//  Created by Rake Yang on 2021/6/17.
//

import Foundation
import SwiftyJSON

public enum ProtoError: Hashable {
    case none
    case unauthorized
    case denied
    case system
    case param
    case db
    case nodata
    case custom(String)
    
    public var rawValue: Int {
        switch self {
        case .none:
            return 0
        case .unauthorized:
            return 401
        case .denied:
            return 402
        case .system:
            return 1001
        case .param:
            return 1002
        case .db:
            return 1003
        case .nodata:
            return 1004
        case .custom(_):
            return 9009
        }
    }
    public var description: String {
        switch self {
        case .none: return ""
        case .unauthorized: return "登录状态失效"
        case .denied: return "Permission denied"
        case .system: return "系统错误"
        case .param: return "参数错误"
        case .nodata: return "数据不存在"
        case .db: return "数据库错误"
        case .custom(let str): return str
        }
    }
}

public struct ProtoResult: Codable {
    /// 状态码，0表示成功
    public var code: Int = 0
    public var error: String?
    public var msg: String?
    public var data: JSON?
    public var timestamp: Int64 = Int64(Date().timeIntervalSince1970*1000)
    
    public init(_ error: ProtoError) {
        if error != .none {
            code = error.rawValue
            self.error = error.description
            msg = error.description
        }
    }
    
    public init(entry: Any) {
        if entry is String || entry is Data || entry is Dictionary<String, Any> || entry is Array<Any> {
            self.data = JSON(entry)
        } else {
            self.data = entry as? JSON
        }
    }
    
    public static var done: Self {
        return .init(.none)
    }
    
    public static func entry(_ entry: Any) -> Self {
        return .init(entry: entry)
    }
}
