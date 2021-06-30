//
//  DefaultValueWrapper.swift
//  
//
//  Created by Rake Yang on 2021/6/23.
//

import Foundation

/**
 # 使用 Property Wrapper 为 Codable 解码设定默认值
  - 原文链接 https://onevcat.com/2020/11/codable-default/
  - 我只是个代码搬运工
 # 这样做的优点
    - 不用为每个类去重写 init(from:) 方法去设置默认值，减少了大量了每个类型添加这么一坨 CodingKeys 和 init(from:)方法，减少重复工作
 */

public protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

@propertyWrapper
public struct Default<T: DefaultValue> {
    public var wrappedValue: T.Value
    
    public init(wrappedValue: T.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension Default: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode<T>( _ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
}

public extension Bool {
    enum False: DefaultValue {
        public static let defaultValue = false
    }
    enum True: DefaultValue {
        public static let defaultValue = true
    }
}

public extension Int {
    enum Zero: DefaultValue {
        public static let defaultValue = 0
    }
}

public extension Int64 {
    enum Zero: DefaultValue {
        public static let defaultValue = 0
    }
}

public extension String {
    enum Empty: DefaultValue {
        public static let defaultValue = ""
    }
}

public extension Default {
    typealias True = Default<Bool.True>
    typealias False = Default<Bool.False>
    typealias Zero = Default<Int.Zero>
    typealias Empty = Default<String.Empty>
}
