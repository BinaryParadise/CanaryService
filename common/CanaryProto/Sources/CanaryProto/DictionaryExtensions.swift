//
//  DictionaryExtensions.swift
//  LibSwifter
//
//  Created by Rake Yang on 2021/5/15.
//

import Foundation
import SwiftyJSON

public extension Dictionary {
    func boolValue(_ key: Key) -> Bool {
        return intValue(key) > 0
    }
    func intValue(_ key: Key) -> Int {
        return Int(int64Value(key))
    }
    
    func int64Value(_ key: Key) -> Int64 {
        guard let value = self[key] else { return 0 }
        if value is String {
            return Int64(value as? String ?? "") ?? 0
        } else if value is Int64 {
            return value as? Int64 ?? 0
        } else if value is Int32 {
            return Int64(value as? Int32 ?? 0)
        } else if value is Int {
            return Int64(value as? Int ?? 0)
        }
        return self[key] as? Int64 ?? 0
    }
    
    func doubleValue(_ key: Key) -> Double {
        guard let value = self[key] else { return 0 }
        if value is String {
            return Double(value as? String ?? "") ?? 0
        } else if value is Int || value is Int32 || value is Int64 {
            return Double(int64Value(key))
        } else if value is Float {
            return Double(value as? Float ?? 0)
        } else if value is Double {
            return Double(value as? Double ?? 0)
        }
        return 0
    }
    
    func stringValue(_ key: Key) -> String {
        guard let value = self[key] else { return "" }
        if value is String {
            return value as? String ?? ""
        } else if value is Int || value is Int32 || value is Int64 {
            return String(int64Value(key))
        } else if value is Float {
            return String(value as? Float ?? 0)
        } else if value is Double {
            return String(value as? Double ?? 0)
        }
        return ""
    }
}

public extension Dictionary {
    var data: Data? {
        return try? JSON(self).rawData()
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data ?? Data())
    }
}

public extension Array {
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: JSON(self).rawData() )
    }
}
