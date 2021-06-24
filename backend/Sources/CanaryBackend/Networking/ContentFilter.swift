//
//  ContentFilter.swift
//
//  Created by Rake Yang on 2021/6/9.
//

import Foundation
import PerfectHTTP
import CanaryProto
import Rainbow
import PerfectSession
import SwiftyJSON

let AccessToken = "Canary-Access-Token"

public struct ContentFilter: HTTPRequestFilter {
    /// 无需鉴权白名单
    let whiteList = ["/channel", "/conf/full", "/info", "/user/login", "/net/snapshot", "/mock/app/scene"]
    /// 需指定角色权限
    let adminList = ["/user/add", "/user/update", "/user/role/list"]
    public init() {
        
    }
    
    func canRequest(request: HTTPRequest) -> Bool {
        let ctxPath = request.path[baseUri.endIndex...]
        if ctxPath == "/" {
            return true
        }
        let contain = whiteList.contains { str in
            ctxPath.starts(with: str)
        }
        if contain {
            return true //无需登录
        } else {
            let token = request.header(.custom(name: AccessToken)) ?? ""
            var user = request.session?.data["user"] as? ProtoUser
            if user == nil && token.count > 0 {
                let nuser = UserMapper.shared.findByToken(token: token, agent: request.header(.userAgent) ?? "unknown")
                user = nuser
                user?.app = try? ProjectMapper.shared.findBy(appId: nuser?.app_id ?? 0)
            } else {
                if user?.invalid ?? false {
                    //会话过期
                    UserMapper.shared.updateByToken(token: token)
                }
            }
            if let user = user {
                request.session?.userid = String(user.id)
                request.session?.data["user"] = user
            }
            return user != nil
        }
    }
    
    func permissionDenied(request: HTTPRequest) -> Bool {
        let ctxPath = request.path[baseUri.endIndex...]
        let contain = adminList.contains { str in
            str.hasPrefix(ctxPath)
        }
        if let user = request.session?.data["user"] as? ProtoUser {
            return contain && user.rolelevel ?? 2 > 0
        }
        return false
    }
    
    public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        if !canRequest(request: request) {
            try? response.setBody(json: ProtoResult(.unauthorized))
            callback(.halt(request, response))
            return
        }
        if permissionDenied(request: request) {
            callback(.halt(request, response))
            try? response.setBody(json: ProtoResult(.unauthorized))
            return
        }
        callback(.continue(request, response))
    }
    
    
}

public extension HTTPRequest {
    var postDictionary: [String : Any] {
        let obj = JSON(parseJSON: postBodyString ?? "")
        return obj.dictionaryObject ?? [:]
    }
    
    var getDictionary: [String : String] {
        var params: [String : String] = [:]
        queryParams.forEach { key, value in
            params[key] = value
        }
        return params
    }
    
    var uid: Int {
        return Int(session?.userid ?? "0")!
    }
    
    var pid: Int {
        return (session?.data["user"] as? ProtoUser)?.app?.id ?? 0
    }
    
    func intParamValue(_ name: String) -> Int {
        if method == .get {
            return getDictionary.intValue(name)
        } else {
            return postDictionary.intValue(name)
        }
    }
    
    func stringParamValue(_ name: String) -> String {
        if method == .get {
            return getDictionary.stringValue(name)
        } else {
            return postDictionary.stringValue(name)
        }
    }
}
