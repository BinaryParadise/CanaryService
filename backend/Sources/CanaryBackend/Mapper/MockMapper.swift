//
//  MockMapper.swift
//  
//
//  Created by Rake Yang on 2021/6/23.
//

import Foundation
import Proto

class MockMapper {
    class func findAllMock(pid: Int, uid: Int, paging: Paging, groupId: Int) throws -> [Any]? {
        var sql = """
        SELECT a.*, b.name as groupname FROM MockData a LEFT JOIN MockGroup b ON a.groupid = b.id WHERE
            b.appid=:1 AND b.uid=:2
        """
        if groupId > 0 {
            sql.append(" AND a.groupid=\(groupId)")
        }
        sql.append(" ORDER BY updatetime desc LIMIT :3,:4")
        return try DBManager.shared.query(statement: sql, args: [pid, uid, paging.begin, paging.end])
    }
    
    class func findAllGroup(pid: Int, uid: Int) throws -> [Any]? {
        let sql = """
        SELECT * FROM MockGroup WHERE appid=:1 and uid=:2
        """
        return try DBManager.shared.query(statement: sql, args: [pid, uid])
    }
    
    class func update(mock: ProtoMock) throws {
        if mock.id > 0 {
            let sql = "UPDATE MockData set name=:1, method=:2, path=:3, groupid=:4, enabled=true, updatetime=null where id=:5"
            try DBManager.shared.execute(statement: sql, args: [mock.name,mock.method,mock.path, mock.groupid,mock.id])
        } else {
            let sql = "INSERT INTO MockData(name, method, path, groupid) values(:1, :2, :3, :4)"
            try DBManager.shared.execute(statement: sql, args: [mock.name, mock.method, mock.path, mock.groupid])
        }
    }
    
    class func activeMock(mockid: Int, enabled: Bool) throws {
        let sql = """
            UPDATE MockData set enabled=(CASE WHEN enabled THEN false ELSE true END), updatetime=null where id=:1
            """
        try DBManager.shared.execute(statement: sql, args: [mockid])
    }
    
    class func deleteMock(mockid: Int) throws {
        try DBManager.shared.execute(statement: "DELETE FROM MockData where id=:1;", args: [mockid])
    }
    
    class func findAllScene(mockid: Int) throws -> [[String : AnyHashable]]? {
        let sql = """
            SELECT a.*, b.sceneid as activeid FROM MockScene a LEFT JOIN MockData b ON a.mockid=b.id
            WHERE mockid=:1 order by updatetime desc
            """
        return try DBManager.shared.query(statement: sql, args: [mockid])
    }
    
    class func findAllParam(sceneid: Int) throws -> [Any]? {
        let sql = """
            SELECT * FROM MockParam WHERE sceneid=:1
            """
        return try DBManager.shared.query(statement: sql, args: [sceneid])
    }
    
    class func findScene(sceneId: Int) throws -> [String : AnyHashable]? {
        return try DBManager.shared.query(statement: "SELECT * FROM MockScene WHERE id=:1", args: [sceneId])?.first
    }
    
    class func updateScene(scene: ProtoMockScene) throws {
        if scene.id > 0 {
            try DBManager.shared.execute(statement: "UPDATE MockScene SET name=:1, response=:2, updatetime=null WHERE id=:3", args: [scene.name, scene.response, scene.id])
        } else {
            try DBManager.shared.execute(statement: "INSERT INTO MockScene(name,response, mockid) VALUES(:1, :2, :3)", args: [scene.name, scene.response, scene.mockid])
        }
    }
    
    class func updateParam(param: ProtoMockParam) throws {
        let sql = """
            INSERT INTO MockParam(name, value, comment, sceneid, updatetime) VALUES(:1, :2, :3,
                  :4, NULL)
            """
        try DBManager.shared.execute(statement: sql, args: [param.name, param.value, param.comment, param.sceneid])
    }
    
    class func deleteParam(paramid: Int) throws {
        try DBManager.shared.execute(statement: "DELETE FROM MockParam where id=:1", args: [paramid])
    }
    
    class func deleteScene(sceneid: Int) throws {
        try DBManager.shared.execute(statement: "DELETE FROM MockScene where id=:1", args: [sceneid])
    }
    
    class func activeScene(_ sceneid: Int, enabled: Bool, mockid: Int = 0) throws {
        if sceneid == 0 {
            let sql = """
                UPDATE MockData SET sceneid=:1, updatetime=null WHERE id=:2
                """
            try DBManager.shared.execute(statement: sql, args: [nil, mockid])
        } else {
            let sql = """
                UPDATE MockData SET sceneid=:1, updatetime=null
                WHERE id=(SELECT mockid FROM MockScene WHERE id=:2)
                """
            try DBManager.shared.execute(statement: sql, args: [enabled ? sceneid: nil, sceneid])
        }
    }
    
    class func updateGroup(_ group: ProtoMockGroup) throws {
        if group.id == 0 {
            let sql = """
                INSERT INTO MockGroup(name,appid, uid) VALUES(:1, :2, :3)
                """
            try DBManager.shared.execute(statement: sql, args: [group.name, group.appid, group.uid])
        }
    }
    
    class func deleteGroup(_ groupid: Int) throws {
        try DBManager.shared.execute(statement: "DELETE FROM MockGroup WHERE id=:1", args: [groupid])
    }
}
