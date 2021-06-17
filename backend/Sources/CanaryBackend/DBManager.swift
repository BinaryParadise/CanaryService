//
//  DBManager.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import PerfectSQLite

enum ColumnType: Int {
    case int = 1
    case text = 3
    case null = 5
}

class DBManager {
    static let shared = DBManager()
    var db: SQLite?
    init() {
        do {
            let dbPath = "\(folder)/\(conf.sqlite)"
            db = try SQLite(dbPath)
        } catch {
            print("\(error)".red)
        }
    }
    
    func execute(statement: String ,args: [Any] = []) throws {
        log(statement: statement, args: args)
        try? db?.execute(statement: statement, doBindings: { stmt in
            for (index, item) in args.enumerated() {
                if let item = item as? String {
                    try? stmt.bind(position: index+1, item)
                } else if let item = item as? Int64 {
                    try? stmt.bind(position: index+1, item)
                }
            }
        })
    }
    
    func query(statement: String, args: [Any] = []) throws -> [[String : AnyHashable]] {
        log(statement: statement, args: args)
        var result: [[String : AnyHashable]] = []
        try? db?.forEachRow(statement: statement, doBindings: { stmt in
            for (index, item) in args.enumerated() {
                if let item = item as? String {
                    try? stmt.bind(position: index+1, item)
                } else if let item = item as? Int64 {
                    try? stmt.bind(position: index+1, item)
                }
            }
        }, handleRow: { stmt, idx in
            var map:[String : AnyHashable] = [:]
            for i in 0..<stmt.columnCount() {
                let type = ColumnType(rawValue: Int(stmt.columnType(position: i))) ?? .null
                let columnName = stmt.columnName(position: i)
                switch type {
                case .int:
                    map[columnName] = stmt.columnInt64(position: i)
                case .text:
                    map[columnName] = stmt.columnText(position: i)
                case .null:
                    break
                }
            }
            result.append(map)
        })
        return result
    }
    
    func log(statement: String, args: [Any]) {
        return
        var sql = statement
        for (index, item) in args.enumerated() {
            if item is String {
                sql = sql.stringByReplacing(string: ":\(index+1)", withString: "'\(item)'")
            } else {                
                sql = sql.stringByReplacing(string: ":\(index+1)", withString: "'\(item)'")
            }
        }
        print("\(#function) `\(sql)`")
    }
    
    deinit {
        db?.close()
    }
}

extension Date {
    static var currentTimeMillis: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
