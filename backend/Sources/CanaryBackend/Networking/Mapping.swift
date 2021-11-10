//
//  Mapping.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import PerfectHTTP
import Proto
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
    public init(wrappedValue: @escaping ResultHandler, path: String, method: [HTTPMethod] = HTTPMethod.allMethods) {
        self.init(path: path, wrappedValue: wrappedValue)
        routes.add(Route(methods: method, uri: path, handler: { request, response in
            do {
                if let rs = try wrappedValue(request, response) {
                    let _ = try response.setBody(json: rs)
                    response.completed(status: .ok)
                } else {
                    //custom
                }
            } catch {
                var result = ProtoResult(.system)
                result.msg = "\(error)"
                if let sqlErr = error as? SQLiteError {
                    if sqlErr.code == 19 {
                        result.msg = "记录已存在"
                    }
                }
                let _ = try? response.setBody(json: result)
                response.completed(status: .ok)
            }
        }))
    }
}

public struct Paging: Codable {
    public var pageSize: Int
    public var pageNum: Int
    
    public var begin: Int {
        return (pageNum-1) * pageSize
    }
    
    public var end: Int {
        return pageNum * pageSize
    }
    
    init(_ params: [String : String]) {
        self.pageSize = params.intValue("pageSize")
        self.pageNum = params.intValue("pageNum")
    }
}
