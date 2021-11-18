//
//  HomeController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/11.
//

import Foundation
import Vapor
import Proto

struct HomeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        var todos = routes
        if let context = Environment.get("context") {
            todos = routes.grouped(.constant(context))
        }
        todos.get(use: index)
        
        let log = routes.grouped("log", "snapshot")
        log.post("add", use: addSnapshot)
        log.get(":identify", use: snapshot)
    }
    func index(req: Request) throws -> String {
        return "Hello, world!"
    }
    
    func info(request: Request) throws -> Response {
        return .init(status: .ok, version: .http1_1, headers: .init(), body: .init(string: "running"))
    }
    
    func addSnapshot(request: Request) throws -> Response {
        try DBManager.shared.execute(statement: "INSERT INTO APISnapshot(identify, data) VALUES(:1, :2)", args: [request.content.get(String.self, at: "identify"), request.body.string])
        return .success()
    }
    
    func snapshot(request: Request) throws -> Response {
        let data = try DBManager.shared.query(statement: "SELECT * FROM APISnapshot WHERE identify=:1", args: [request.parameters.get("identify") as Any])?.first
        if request.headers.first(name: .xRequestedWith) == "XMLHttpRequest" {
            return Response(status: .ok, version: .http1_1, headersNoUpdate: [:], body: .init(data: (data?.data)!))
        } else {
            let response = Response(status: .ok, version: .http1_1, headers: .init(), body: .init(string: """
                    <html>
                    <head>
                        <title>接口请求响应快照 - 金丝雀</title>
                        <meta property="og:title" content="接口请求响应快照" />
                        <meta property="og:url" content="\(data?["url"] as? String ?? "")" />
                        <meta property="og:description" content="可查看请求和响应的详细数据" />
                    </head>
                    <body>Open Graph Data</body>
                    </html>
                    """))
            response.headers.replaceOrAdd(name: .contentType, value: "text/html; charset=utf8")
            return response
        }
    }
}
