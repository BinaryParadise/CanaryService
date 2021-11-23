//
//  ConfController.swift
//  
//
//  Created by Rake Yang on 2021/6/18.
//

import Foundation
import Proto
import Vapor
import SwiftyJSON

struct ConfController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("conf") { conf in
            conf.get("list", use: list)
            conf.get("full", use: full)
            conf.post("update", use: update)
        }
        
        routes.group("env") { env in
            env.get("list", use: envlist)
            env.post("update", ":id", use: envupdate)
            env.post("delete", ":id", use: envdelete)
        }
    }
    
    func list(request: Request) throws -> Response {
        let rs = try ConfMapper.shared.findAll(pid: request.pid, type: request.content.intValue("type"))
        return .success(try JSON(rs as Any).rawData())
    }
    
    func full(request: Request) throws -> Response {
        let rs = try ConfMapper.shared.findFull(pid: request.pid)
        return .success(try JSONEncoder().encode(rs))
    }
    
    func update(request: Request) throws -> Response {
        return .success()
    }
    
    func envlist(request: Request) throws -> Response {
        let rs = try ConfMapper.shared.findItemAll(envid: request.query.intValue("id"))
        return .success(try JSON(rs as Any).rawData())
    }
    
    func envupdate(request: Request) throws -> Response {
        var env = try request.content.decode(ProtoConfItem.self)
        env.uid = request.uid
        try ConfMapper.shared.updateItem(env: env)
        return .success()
    }
    
    func envdelete(request: Request) throws -> Response {
        try ConfMapper.shared.deleteItem(itemid: request.parameters.intValue("id"))
        return .success()
    }
}
