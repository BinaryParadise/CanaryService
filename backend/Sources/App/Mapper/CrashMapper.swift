//
//  CrashMapper.swift
//  
//
//  Created by Rake Yang on 2021/12/16.
//

import Foundation
import Proto

class CrashMapper {
    class func fetch(deviceid: String) throws -> [[String : AnyHashable]]? {
        var ret = try DBManager.shared.query(statement: "SELECT * FROM CrashLog WHERE deviceid=:1 ORDER BY updateTime DESC", args: [deviceid])
        for i in 0..<(ret?.count ?? 0) {
            if let exc = ret![i]["exception"] as? String {
                let json = try? JSONSerialization.jsonObject(with: exc.data(using: .utf8)!, options: .mutableLeaves) as? [String: AnyHashable]
                json?.forEach({ (key: String, value: AnyHashable) in
                    ret?[i][key] = value
                })
                ret?[i].removeValue(forKey: "exception")
            }
        }
        return ret
    }
    
    class func fetch(cid: Int) throws -> [String : AnyHashable]? {
        var ret = try DBManager.shared.query(statement: "SELECT * FROM CrashLog WHERE id=:1 ORDER BY updateTime DESC", args: [cid])?.first
        if let exc = ret?["exception"] as? String {
            let json = try? JSONSerialization.jsonObject(with: exc.data(using: .utf8)!, options: .mutableLeaves) as? [String: AnyHashable]
            json?.forEach({ (key: String, value: AnyHashable) in
                ret?[key] = value
            })
            ret?.removeValue(forKey: "exception")
        }
        return ret
    }
    
    class func insert(crash: String, deviceid: String) throws {
        let sql = """
        INSERT INTO CrashLog(deviceid, exception, updateTime) VALUES(:1,:2,null)
        """
        try DBManager.shared.execute(statement: sql, args: [deviceid, crash])
    }
}
