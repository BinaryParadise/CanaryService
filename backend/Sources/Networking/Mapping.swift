//
//  Mapping.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import PerfectHTTP

public var routes = Routes()

@propertyWrapper
public struct Mapping {
    var path: String
    var description: String?
    public var wrappedValue: RequestHandler
}

extension Mapping {
    public init(wrappedValue:@escaping RequestHandler, path: String, method: HTTPMethod = .get, description: String? = nil) {
        self.init(path: path, description: description, wrappedValue: wrappedValue)
        routes.add(method: method, uri: path, handler: wrappedValue)
    }
}
