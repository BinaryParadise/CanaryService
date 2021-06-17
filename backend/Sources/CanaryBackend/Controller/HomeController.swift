//
//  HomeController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/11.
//

import Foundation
import Networking
import PerfectHTTP
import Rainbow

class HomeController {
    @Mapping(path: "/", method: .get)
    var home: ResultHandler = { request, response in
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!<br/>\(Date())</body></html>")
        response.completed()
        return nil
    }
    
    @Mapping(path: "/info", method: .get)
    var info: ResultHandler = { request, response in
        response.setHeader(.contentType, value: "application/json")
        let _ = try? response.setBody(json: ["version": "1.0",
                                             "server": "Canary/Perfect1.0",
                                             "timestamp": UInt64(Date().timeIntervalSince1970*1000)])
        response.completed()
        return nil
    }
}
