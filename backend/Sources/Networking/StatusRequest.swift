//
//  StatusRequest.swift
//  PerfectTemplate
//
//  Created by Rake Yang on 2021/6/9.
//

import Foundation
import PerfectHTTP

public struct ContentFilter: HTTPRequestFilter {
    public init() {
        
    }
    
    public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        callback(.continue(request, response))
    }
    
    
}
