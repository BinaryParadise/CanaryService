//
//  File.swift
//  
//
//  Created by Rake Yang on 2021/6/17.
//

import Foundation
import CanaryProto

struct UserMapper {
    static var shared = UserMapper()
    
    func login(username: String, password: String, agent: String) -> String {
        let token = CanaryProto.generateIdentify()
        try? DBManager.shared.execute(statement:login, args: [token, username, password, agent])
        return token
    }
    
    func findByLogin(args: Any...) -> [String : AnyHashable]? {
        return try? DBManager.shared.query(statement: findByLogin, args: args).first
    }
    
    func updateByToken(token: String) {
        try? DBManager.shared.execute(statement: "UPDATE UserSession SET expire=:1 WHERE token=:2", args: [Date.currentTimeMillis, token])
    }
    
    func findByToken(token: String, agent: String) -> ProtoUser? {
        let item = try? DBManager.shared.query(statement: findByToken, args: [agent, token, Date.currentTimeMillis]).first
        return try? JSONDecoder().decode(ProtoUser.self, from: item?.data ?? Data())
    }
    
    func changeApp(uid: Int, pid: Int) throws {
        try DBManager.shared.execute(statement: "UPDATE User set appid=:1 where id=:2", args: [pid, uid])
    }
    
    private var login: String {
        return """
                INSERT OR REPLACE INTO UserSession (token, expire, uid, platform ) SELECT
                :1,
                \(Int64(Date().timeIntervalSince1970*1000))+3600*24*7*1000,
                ( SELECT id FROM User a WHERE a.username = :2 AND a.password = :3 and deleteTag=0 ), :4
        """
    }
    
    private var findByToken: String {
        return """
        SELECT a.*,
            d.token,
            d.expire,
            d.platform,
            b.name AS rolename,
            b.level AS rolelevel,
            c.id AS app_id,
            c.name AS app_name,
            c.identify AS app_identify,
            c.shared AS app_shared
            FROM
            User a
            LEFT JOIN UserRole b ON a.roleid = b.id
            LEFT JOIN Project c ON a.appid = c.id
            LEFT JOIN UserSession d ON a.id = d.uid
            WHERE
            d.platform = :1
            AND d.token= :2
            AND d.expire > :3
        """
    }
    
    private var findByLogin: String {
        return """
SELECT a.*,
    d.token,
    d.expire,
    d.platform,
    b.name AS rolename,
    b.level AS rolelevel,
    c.id AS app_id
    FROM
    User a
    LEFT JOIN UserRole b ON a.roleid = b.id
    LEFT JOIN Project c ON a.appid = c.id
    LEFT JOIN UserSession d ON a.id = d.uid
    WHERE
    a.username = :1
    AND a.password = :2
    AND d.platform = :3
    AND d.token= :4
    AND d.expire > :5
"""
    }
}
