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
            conf.post("update", ":id", use: update)
            conf.post("delete", ":id", use: delete)
        }
        
        routes.group("env") { env in
            env.get("list", use: envlist)
            env.post("update", ":id", use: envupdate)
            env.post("delete", ":id", use: envdelete)
        }
    }
    
    func list(request: Request) throws -> Response {
        let rs = try ConfMapper.shared.findAll(pid: request.pid, type: request.query.intValue("type"))
        return .success(try JSON(rs as Any).rawData())
    }
    
    func full(request: Request) throws -> Response {
        var pid = request.pid        
        if let appkey = request.query.stringValue("appkey") {
            guard let app = try ProjectMapper.shared.findBy(appKey: appkey) else { return .failed(.unauthorized)}
            pid = app.id
        }
        let rs = try ConfMapper.shared.findFull(pid: pid)
        return .success(try JSONEncoder().encode(rs))
    }
    
    func update(request: Request) throws -> Response {
        var conf = try request.content.decode(ProtoConf.self)
        conf.appId = request.pid
        try ConfMapper.shared.update(conf: conf)
        return .done()
    }
    
    func delete(request: Request) throws -> Response {
        try ConfMapper.shared.delete(envid: request.parameters.intValue("id"))
        return .done()
    }
    
    func envlist(request: Request) throws -> Response {
        let rs = try ConfMapper.shared.findItemAll(envid: request.query.intValue("id"))
        return .success(try JSON(rs as Any).rawData())
    }
    
    func envupdate(request: Request) throws -> Response {
        var env = try request.content.decode(ProtoConfItem.self)
        env.uid = request.uid
        try ConfMapper.shared.updateItem(env: env)
        return .done()
    }
    
    func envdelete(request: Request) throws -> Response {
        try ConfMapper.shared.deleteItem(itemid: request.parameters.intValue("id"))
        return .done()
    }
}
