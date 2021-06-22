//
//  ProjectMapper.swift
//  
//
//  Created by Rake Yang on 2021/6/17.
//

import Foundation
import CanaryProto

struct ProjectMapper {
    static var shared = ProjectMapper()
    
    func findBy(appId: Int) throws -> ProtoProject? {
        if appId == 0 {
            return nil
        }
        return try DBManager.shared.query(statement: findById, args: [appId]).first?.decode(ProtoProject.self)
    }
    
    func findBy(appKey: String) throws -> ProtoProject? {
        let result = try DBManager.shared.query(statement: "SELECT * FROM Project WHERE identify=:1", args: [appKey])
        return try result.first?.decode(ProtoProject.self)
    }
    
    func findAll(uid: Int) -> Any? {
        return try? DBManager.shared.query(statement: findAll, args: [uid])
    }
    
    func update(_ app: ProtoProject) throws {
        return try DBManager.shared.execute(statement: "UPDATE Project set name=:1, shared=:2, identify=:3, updateTime=null where id=:4", args: [app.name, app.shared, app.identify, app.id])
    }
    
    func delete(appid: Int) throws {
        try DBManager.shared.execute(statement: "DELETE FROM Project WHERE id=:1", args: [appid])
    }
    
    func insertNew(_ app: ProtoProject) throws {
        let sql = """
        INSERT INTO Project(name,identify,orderno, uid, shared) values(:1, :2, 1, :3, :4)
        """
        return try DBManager.shared.execute(statement: sql, args: [app.name, app.identify, app.uid, app.shared])
    }
    
    private var findById: String {
        return "SELECT * FROM Project WHERE id=:1"
    }
    
    private var findAll: String {
        return """
SELECT
    a.*,
    b.name AS author
    FROM
    Project a
    LEFT JOIN User b ON a.uid = b.id
    WHERE
    a.enable = 1 and (a.shared=1 OR (a.shared=0 AND a.uid=:1))
    ORDER BY
    a.orderno ASC
"""
    }
}
