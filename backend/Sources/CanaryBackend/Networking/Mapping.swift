//
//  Mapping.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import PerfectHTTP
import CanaryProto

public var routes = Routes()
public var baseUri = ""

public typealias ResultHandler = (HTTPRequest, HTTPResponse) -> ProtoResult?

@propertyWrapper
public struct Mapping {
    var path: String
    var description: String?
    public var wrappedValue: ResultHandler
}

extension Mapping {
    public init(wrappedValue:@escaping ResultHandler, path: String, method: HTTPMethod = .get, description: String? = nil) {
        self.init(path: path, description: description, wrappedValue: wrappedValue)
        routes.add(method: method, uri: path) { request, response in
            if let rs = wrappedValue(request, response) {
                let _ = try? response.setBody(json: rs)
                response.completed(status: .ok)
            } else {
                //custom
            }
        }
    }
}
