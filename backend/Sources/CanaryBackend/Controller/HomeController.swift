//
//  HomeController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/11.
//

import Foundation
import PerfectHTTP
import Proto

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
    
    @Mapping(path: "/log/snapshot/{identify}")
    var snapshot: ResultHandler = { request, response in
        let data = try DBManager.shared.query(statement: "SELECT * FROM APISnapshot WHERE identify=:1", args: [request.urlVariables["identify"]])?.first
        let obj = try JSONSerialization.jsonObject(with: (data?["data"] as? String)?.data(using: .utf8) ?? Data(), options: .mutableLeaves)
        if request.header(.xRequestedWith) == "XMLHttpRequest" {
            return .entry(obj)
        } else {
            response.setHeader(.contentType, value: "text/html; charset=utf-8")
            if let dict = obj as? NSDictionary {
                response.setBody(string: """
                    <html>
                    <head>
                        <title>接口请求响应快照 - 金丝雀</title>
                        <meta property="og:title" content="接口请求响应快照" />
                        <meta property="og:url" content="\(dict["url"] as? String ?? "")" />
                        <meta property="og:description" content="可查看请求和响应的详细数据" />
                    </head>
                    <body>Open Graph Data</body>
                    </html>
                    """)
                response.completed(status: .ok)
            }
            return nil
        }
    }
}
