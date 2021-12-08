//
//  ContentFilter.swift
//
//  Created by Rake Yang on 2021/6/9.
//

import Foundation
import Proto
import SwiftyJSON
import Vapor

let AccessToken = "Canary-Access-Token"

public struct Paging: Codable {
    public var pageSize: Int
    public var pageNum: Int
    
    public var begin: Int {
        return (pageNum-1) * pageSize
    }
    
    public var end: Int {
        return pageNum * pageSize
    }
    
    init(_ params: [String : String]) {
        self.pageSize = params.intValue("pageSize")
        self.pageNum = params.intValue("pageNum")
    }
}

public struct ContentFilter: Middleware {
    /// 无需鉴权白名单
    let whiteList = ["/channel", "/info", "/user/login", "/net/snapshot", "/mock/app/scene", "/log/snapshot/"]
    /// 需指定角色权限
    let adminList = ["/user/add", "/user/update", "/user/role/list"]
    var contextPath: String = ""
    public init() {
        if let path = Environment.get("context") {
            contextPath = "/\(path)"
        }
    }
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        if !canRequest(request: request) {
            return request.eventLoop.makeSucceededFuture(Response(status: .unauthorized, version: .http1_1, headers: .init(), body: .empty))
        }
        if permissionDenied(request: request) {
            return request.eventLoop.makeSucceededFuture(Response(status: .unauthorized, version: .http1_1, headers: .init(), body: .empty))
        }
        let response = next.respond(to: request).flatMapErrorThrowing { error in
            return .failed(.custom(error.localizedDescription))
        }
        response.whenSuccess { r in
            if !r.headers.contains(name: .contentType) {                
                r.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf8")
            }
        }
        return response
    }
    
    func canRequest(request: Request) -> Bool {
        let ctxPath = String(request.url.path[contextPath.endIndex...])
        if ctxPath == "/" {
            return true
        }
        let contain = whiteList.contains { str in
            ctxPath.starts(with: str)
        }
        if contain {
            return true //无需登录
        } else {
            let token = request.headers.first(name: AccessToken) ?? ""
            var user = request.session.data.get(key: "user", type: ProtoUser.self)
            if user == nil && token.count > 0 {
                let nuser = UserMapper.shared.findByToken(token: token, agent: request.headers.first(name: .userAgent) ?? "unknown")
                user = nuser
                user?.app = try? ProjectMapper.shared.findBy(appId: nuser?.app_id ?? 0)
            } else {
                if user?.invalid ?? false {
                    //会话过期
                    UserMapper.shared.updateByToken(token: token)
                }
            }
            if let user = user {
                request.session.data["userid"] = String(user.id)
                request.session.data["user"] = String(data: user.encodedData() ?? Data(), encoding: .utf8)
            }
            return user != nil
        }
    }
    
    func permissionDenied(request: Request) -> Bool {
        let ctxPath = request.url.path[contextPath.endIndex...]
        if ctxPath == "/" {
            return false
        }
        let contain = adminList.contains { str in
            str.hasPrefix(ctxPath)
        }
        if let user = request.session.data.get(key: "user", type: ProtoUser.self) {
            return contain && user.rolelevel ?? 2 > 0
        }
        return false
    }
}

public extension Request {
    var uid: Int {
        get {
            let userid = session.data["userid"]
            return Int(userid ?? "0") ?? 0
        }
        set {
            session.data["userid"] = String(newValue)
        }
    }
    
    var pid: Int {
        let user = session.data.get(key: "user", type: ProtoUser.self)
        return user?.app?.id ?? 0
    }
}

extension URLQueryContainer {
    func intValue(_ name: String, file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line) -> Int {
        do {
            return try get(Int.self, at: name)
        } catch {
            LogError("\(error)", file: file, function: function, line: line)
        }
        return 0
    }
    
    func stringValue(_ name: String) -> String {
        do {
            return try get(String.self, at: name)
        } catch {
            LogError("\(error)")
        }
        return ""
    }
}

extension Parameters {
    func intValue(_ name: String) -> Int {
        return Int(self.get(name) ?? "0")!
    }
}

extension Request.Body {
    func dictionary() throws -> [String : AnyHashable] {
        guard let data = data else { throw ProtoError.param }
        return try JSONSerialization.jsonObject(with: data) as! [String : AnyHashable]
    }
}

extension ContentContainer {
    func intValue(_ name: String) -> Int {
        do {
            return try get(Int.self, at: name)
        } catch {
            LogError("\(error)")
        }
        return 0
    }
    
    func stringValue(_ name: String) -> String {
        do {
            return try get(String.self, at: name)
        } catch {
            LogError("\(error)")
        }
        return ""
    }
}

extension SessionData {
    func get<T: Decodable>(key: String, type: T.Type) -> T? {
        do {
            guard let data = self[key]?.data(using: .utf8) else {
                return nil
            }
            return try JSONDecoder().decode(type, from: data)
        } catch {
            LogError("\(error)")
            return nil
        }
    }
}
