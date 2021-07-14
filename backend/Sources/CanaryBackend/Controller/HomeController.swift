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
    @Mapping(path: "/")
    var home: ResultHandler = { request, response in
        var rs = ProtoResult(.none)
        rs.msg = "Hello, world!"
        return rs
    }
    
    @Mapping(path: "/info")
    var info: ResultHandler = { request, response in
        response.setHeader(.contentType, value: "application/json")
        let _ = try? response.setBody(json: ["version": "1.0",
                                             "server": "Canary/Perfect1.0",
                                             "timestamp": UInt64(Date().timeIntervalSince1970*1000)])
        response.completed()
        return nil
    }
    
    @Mapping(path: "/net/snapshot/add", method: [.post])
    var addSnapshot: ResultHandler = { request, response in
        try DBManager.shared.execute(statement: "INSERT INTO APISnapshot(identify, data) VALUES(:1, :2)", args: [request.postDictionary["identify"] as? String, request.postBodyString])
        return .done
    }
    
    @Mapping(path: "/net/snapshot/{identify}")
    var snapshot: ResultHandler = { request, response in
        let data = try DBManager.shared.query(statement: "SELECT * FROM APISnapshot WHERE identify=:1", args: [request.urlVariables["identify"]])?.first
        let obj = try JSONSerialization.jsonObject(with: (data?["data"] as? String)?.data(using: .utf8) ?? Data(), options: .mutableLeaves)
        return .entry(obj)
    }
}
