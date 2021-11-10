//
//  UserController.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import PerfectHTTP
import SwiftyJSON
import Proto

class UserController {
    @Mapping(path: "/user/login", method: [.post])
    var login: ResultHandler = { request, response in
        let args = request.postDictionary
        do {
            let username = args.stringValue("username")
            let password = args.stringValue("password")
            let agent = request.header(.userAgent) ?? "unknown"
            let token = try UserMapper.shared.login(username: username, password: password, agent: agent)
            if var user = try UserMapper.shared.findByLogin(args: [username, password, agent, token, Date.currentTimeMillis])?.decode(ProtoUser.self) {
                request.session?.userid = String(user.id)
                user.app = try ProjectMapper.shared.findBy(appId: user.app_id ?? 0)
                response.addCookie(HTTPCookie.init(name: "token", value: token))
                return ProtoResult(entry: try JSONEncoder().encode(user))
            }
        } catch {
            LogError("\(error)")
        }
        return ProtoResult(.custom("用户名或密码错误"))
    }
    
    @Mapping(path: "/user/change/app", method: [.post])
    var change: ResultHandler = { request, response in
        let args = request.postDictionary
        try UserMapper.shared.changeApp(uid: args.intValue("uid"), pid: args.intValue("id"))
        var user = UserMapper.shared.findByToken(token: request.header(.custom(name: AccessToken))!, agent: request.header(.userAgent) ?? "unknown")
        user?.app = try? ProjectMapper.shared.findBy(appId: args.intValue("id"))
        request.session?.data["user"] = user
        return ProtoResult(entry: try JSONEncoder().encode(user))
    }
    
    @Mapping(path: "/user/list")
    var list: ResultHandler = { request, response in
        return ProtoResult(entry: try UserMapper.shared.findAll())
    }
    
    @Mapping(path: "/user/update", method: [.post])
    var updateUser: ResultHandler = { request, response in
        let user = try request.postDictionary.decode(ProtoUser.self)
        try UserMapper.shared.update(user: user)
        return .done
    }
    
    @Mapping(path: "/user/resetpwd", method: [.post])
    var resetPwd: ResultHandler = { request, response in
        var user = ProtoUser()
        user.id = request.postDictionary.intValue("id")
        user.password = request.postDictionary.stringValue("password")
        try UserMapper.shared.resetPwd(user: user)
        return .done
    }
    
    @Mapping(path: "/user/delete/{uid}", method: [.post])
    var deleteUser: ResultHandler = { request, response in
        try UserMapper.shared.delete(uid: request.urlVariables.intValue("uid"))
        return .done
    }
    
    @Mapping(path: "/user/role/list")
    var roleList: ResultHandler = { request, response in
        return .entry(try UserMapper.shared.findRoleList())
    }
}
