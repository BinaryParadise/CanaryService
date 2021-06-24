//
//  HomeController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/11.
//

import Foundation
import PerfectHTTP
import CanaryProto

class HomeController {
    @Mapping(path: "/", method: .get)
    var home: ResultHandler = { request, response in
        var rs = ProtoResult(.none)
        rs.msg = "Hello, world!"
        return rs
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
