//
//  Mapping.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import PerfectHTTP
import CanaryProto
import PerfectSQLite

public var routes = Routes()
public var baseUri = ""

public typealias ResultHandler = (HTTPRequest, HTTPResponse) throws -> ProtoResult?

@propertyWrapper
public struct Mapping {
    var path: String
    public var wrappedValue: ResultHandler
}

extension Mapping {
    public init(wrappedValue: @escaping ResultHandler, path: String, method: HTTPMethod = .get) {
        self.init(path: path, wrappedValue: wrappedValue)
        routes.add(method: method, uri: path) { request, response in
            do {
                if let rs = try wrappedValue(request, response) {
                    let _ = try response.setBody(json: rs)
                    response.completed(status: .ok)
                } else {
                    //custom
                }
            } catch {
                var result = ProtoResult(.system)
                result.error = "\(error)"
                if let sqlErr = error as? SQLiteError {
                    if sqlErr.code == 19 {
                        result.error = "违反唯一约束"
                    }
                }
                let _ = try? response.setBody(json: result)
                response.completed(status: .ok)
            }
        }
    }
}
