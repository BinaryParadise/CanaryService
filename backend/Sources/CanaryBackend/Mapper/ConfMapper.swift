//
//  ConfMapper.swift
//  
//
//  Created by Rake Yang on 2021/6/18.
//

import Foundation
import Proto
import SwiftyJSON

struct ConfMapper {
    static var shared = ConfMapper()
    
    func findFull(pid: Int) throws -> [ProtoConfGroup] {
        var groups: [ProtoConfGroup] = []
        
        for type in [.test, .dev, .production] as [ConfType] {
            var group = ProtoConfGroup(type)
            do {
                let result = try findAll(pid: pid, type: group.type.rawValue)
                group.items = try JSONDecoder().decode([ProtoConf].self, from: JSON(result).rawData())
                for (i, item) in group.items.enumerated() {
                    let subrs = try findItemAll(envid: item.id)
                    group.items[i].subItems = try JSONDecoder().decode([ProtoConfItem].self, from: JSON(subrs).rawData())
                }
            } catch {
                LogError("\(error)")
            }
            groups.append(group)
        }
        return groups
    }
    
    func findAll(pid: Int, type: Int) throws -> [[String : AnyHashable]]? {
        return try DBManager.shared.query(statement: findAll, args: [pid, type])
    }
    
    func findItemAll(envid: Int) throws -> [[String : AnyHashable]]? {
        return try DBManager.shared.query(statement: itemAll, args: [envid])
    }
    
    func updateItem(env: ProtoConfItem) throws {
        if env.id == 0 {
            let sql = """
            INSERT INTO RemoteConfigParam(`name`, `value`, envid, `comment`, uid,`type`,`platform`)
            VALUES(:1,:2,:3,:4,:5,0,:6)
            """
            return try DBManager.shared.execute(statement: sql, args: [env.name, env.value, env.envid, env.comment, env.uid, 0])
        } else {
            let sql = """
            UPDATE RemoteConfigParam SET
                `name`=:1,`value`=:2,`comment`=:3,`uid`=:4, updateTime=null where id=:5
            """
            return try DBManager.shared.execute(statement: sql, args: [env.name, env.value, env.comment, env.uid, env.id])
        }
    }
    
    private var findAll: String {
        return """
        SELECT
            a.*, b.name as author,
            ( SELECT count( * ) FROM RemoteConfigParam WHERE envid = a.id ) AS subItemsCount
            FROM
            RemoteConfig a LEFT JOIN User b on a.uid = b.id
            WHERE
            a.appId = :1
            AND
            a.type = :2
            ORDER BY
            updateTime DESC
        """
    }
    
    private var itemAll: String {
        return """
        select a.*,b.name as author from RemoteConfigParam a LEFT JOIN User b on a.uid=b.id where envid=:1 order by
            updateTime desc
        """
    }
}
