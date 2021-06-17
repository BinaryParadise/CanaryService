//
//  ProjectMapper.swift
//  
//
//  Created by Rake Yang on 2021/6/17.
//

import Foundation

struct ProjectMapper {
    static var shared = ProjectMapper()
    
    func findBy(appId: Int) -> [String : AnyHashable]? {
        return try? DBManager.shared.query(statement: findById, args: [appId]).first
    }
    
    func findAll(uid: Int) -> Any? {
        return try? DBManager.shared.query(statement: findAll, args: [uid])
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
