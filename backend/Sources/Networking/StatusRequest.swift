//
//  StatusRequest.swift
//  PerfectTemplate
//
//  Created by Rake Yang on 2021/6/9.
//

import Foundation
import PerfectHTTP

public struct ContentFilter: HTTPResponseFilter {
    public init() {
        
    }
    public func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    public func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if response.header(.contentType) != "application/json" {
            response.setHeader(.contentType, value: "text/html;charset=utf-8")
        }
        callback(.continue)
    }
    
    
}
