//
//  UserController.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import SwiftyJSON
import Proto
import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.group("user") { user in
            user.post("login", use: login)
            user.post("change", "app", use: switchApp)
            user.get("list", use: list)
            user.post("update", use: update)
            user.post("resetpwd", use: resetPwd)
            user.post("delete", ":uid", use: deleteUser)
            user.get("role", "list", use: roleList)
        }
    }
    
    func login(request: Request) throws -> Response {
        do {
            let username = request.content.stringValue("username")
            let password = request.content.stringValue("password")
            let agent = request.headers.first(name: .userAgent) ?? "unknown"
            let token = try UserMapper.shared.login(username: username, password: password, agent: agent)
            if var user = try UserMapper.shared.findByLogin(args: [username, password, agent, token, Date.currentTimeMillis])?.decode(ProtoUser.self) {
                request.uid = user.id
                user.app = try ProjectMapper.shared.findBy(appId: user.app_id ?? 0)
                let response = Response.success(try JSONEncoder().encode(user))
                response.cookies["name"] = .init(string: token)
                return response
            }
        } catch {
            LogError("\(error)")
        }
        return .failed(.custom("用户名或密码错误"))
    }
    
    func switchApp(request: Request) throws -> Response {
        //TODO: 切换app
        let pid = try request.content.get(Int.self, at: "id")
        try UserMapper.shared.changeApp(uid: request.uid, pid: pid)
        var user = UserMapper.shared.findByToken(token: request.headers.first(name: AccessToken)!, agent: request.headers.first(name: .userAgent) ?? "unknown")
        user?.app = try? ProjectMapper.shared.findBy(appId: pid)
        let r = try JSONEncoder().encode(user)
        request.session.data["user"] = String(data: r, encoding: .utf8)
        return .success(r)
    }
    
    func list(request: Request) throws -> Response {
        let r = try UserMapper.shared.findAll()
        return .success(try JSON(r as Any).rawData())
    }
    
    func update(request: Request) throws -> Response {
        let user = try request.content.decode(ProtoUser.self)
        try UserMapper.shared.update(user: user)
        return .done()
    }
    
    func resetPwd(request: Request) throws -> Response {
        var user = ProtoUser()
        user.id = try request.content.get(Int.self, at: "id")
        user.password = try request.content.get(String.self, at: "password")
        try UserMapper.shared.resetPwd(user: user)
        return .done()
    }
    
    func deleteUser(request: Request) throws -> Response {
        try UserMapper.shared.delete(uid: Int(request.parameters.get("uid") ?? "")!)
        return .done()
    }
    
    func roleList(request: Request) throws -> Response {
        let r = try UserMapper.shared.findRoleList()
        return .success(try JSON(r as Any).rawData())
    }
}
