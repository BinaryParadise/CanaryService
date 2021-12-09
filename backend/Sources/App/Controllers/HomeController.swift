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
        routes.get(use: index)
        
        let log = routes.grouped("snapshot")
        log.post("add", use: addSnapshot)
        log.get("view", ":identify", use: snapshot)
    }
    func index(request: Request) throws -> Response {
        let response = Response(status: .ok, version: .http1_1, headers: [:], body: .init(string: """
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset='utf-8'>
                <meta http-equiv='X-UA-Compatible' content='IE=edge'>
                <title>金丝雀</title>
                <meta name='viewport' content='width=device-width, initial-scale=1'>
            </head>

            <body>
                <h1 style="color: orange">
                    Canary worked on!</h1>
                <img src="https://img.phb123.com/uploads/allimg/190403/41-1Z403140I2-52.jpg" width="180" />
            </body>

            </html>

            """))
        response.headers.replaceOrAdd(name: .contentType, value: "text/html; charset=utf8")
        return response
    }
    
    func info(request: Request) throws -> Response {
        return .init(status: .ok, version: .http1_1, headers: .init(), body: .init(string: "running"))
    }
    
    func addSnapshot(request: Request) throws -> Response {
        try DBManager.shared.execute(statement: "INSERT INTO APISnapshot(identify, data) VALUES(:1, :2)", args: [request.content.get(String.self, at: "identify"), request.body.string])
        return .done()
    }
    
    func snapshot(request: Request) throws -> Response {
        guard let idenfity = request.parameters.get("identify") else {
            return .failed(.param)
        }
        guard let data = try DBManager.shared.query(statement: "SELECT * FROM APISnapshot WHERE identify=:1", args: [idenfity])?.first else {
            return .failed(.nodata)
        }
        if request.headers.first(name: .xRequestedWith) == "XMLHttpRequest" {
            return .success(data["data"] as? String)
        } else {
            let response = Response(status: .ok, version: .http1_1, headers: .init(), body: .init(string: """
                    <html>
                    <head>
                        <title>接口请求响应快照 - 金丝雀</title>
                        <meta property="og:title" content="接口请求响应快照" />
                        <meta property="og:url" content="\(data["url"] as? String ?? "")" />
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
