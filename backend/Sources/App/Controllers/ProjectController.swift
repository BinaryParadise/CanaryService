//
//  ProjectController.swift
//  CanaryBackend
//
//  Created by Rake Yang on 2021/6/10.
//

import Foundation
import Vapor
import Proto
import SwiftyJSON

/// 应用管理
class ProjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("project") { proj in
            proj.get("list", use: list)
            proj.post("update", use: update)
            proj.post("delete", ":id", use: delete)
            proj.post("appsecret", "reset", use: resetAppKey)
        }
    }

    func list(request: Request) throws -> Response {
        let rs = ProjectMapper.shared.findAll(uid: request.uid)
        return .success(try JSON(rs as Any).rawData())
    }
    
    func update(request: Request) throws -> Response {
        var app = try request.content.decode(ProtoProject.self)
        app.uid = request.uid
        if app.id > 0 {
            let old = try ProjectMapper.shared.findBy(appId: app.id)
            app.identify = old?.identify
            try ProjectMapper.shared.update(app)
        } else {
            app.identify = CanaryProto.generateIdentify()
            try ProjectMapper.shared.insertNew(app)
        }
        return .done()
    }
    
    func delete(request: Request) throws -> Response {
        try ProjectMapper.shared.delete(appid: request.parameters.intValue("id"))
        return .done()
    }
    
    func resetAppKey(request: Request) throws -> Response {
        var app = try request.content.decode(ProtoProject.self)
        app.identify = CanaryProto.generateIdentify()
        try ProjectMapper.shared.update(app)
        return .done()
    }
}
