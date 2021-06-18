//
//  UserController.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import Networking
import PerfectHTTP
import Rainbow
import SwiftyJSON
import CanaryProto

class UserController {
    @Mapping(path: "/user/login", method: .post, description: "用户登录")
    var login: ResultHandler = { request, response in
        let args = request.postDictionary
        do {
            let username = args.stringValue("username")
            let password = args.stringValue("password")
            let agent = request.header(.userAgent) ?? "unknown"
            let token = try UserMapper.shared.login(username: username, password: password, agent: agent)
            if var user = UserMapper.shared.findByLogin(args: username, password, agent, token, Date.currentTimeMillis) {
                request.session?.userid = user.stringValue("uid")
                user["app"] = try ProjectMapper.shared.findBy(appId: user.intValue("app_id"))
                return ProtoResult(entry: user)
            } else {
                return ProtoResult(.custom("用户名或密码错误"))
            }
        } catch {
            print("\(error)".red)
        }
        return ProtoResult(.system)
    }
    
    @Mapping(path: "/user/change/app", method: .post)
    var change: ResultHandler = { request, response in
        let args = request.postDictionary
        try UserMapper.shared.changeApp(uid: args.intValue("uid"), pid: args.intValue("id"))
        var user = UserMapper.shared.findByToken(token: request.header(.custom(name: AccessToken))!, agent: request.header(.userAgent) ?? "unknown")
        user?.app = try? ProjectMapper.shared.findBy(appId: args.intValue("id"))?.decode(ProtoProject.self)
        return ProtoResult(entry: try JSONEncoder().encode(user))
    }
}
