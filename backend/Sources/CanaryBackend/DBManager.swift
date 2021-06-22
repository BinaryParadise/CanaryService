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
    case boolean = 4
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
        try db?.execute(statement: statement, doBindings: { stmt in
            try self.bindArgs(stmt: stmt, args: args)
        })
    }
    
    func query(statement: String, args: [Any] = []) throws -> [[String : AnyHashable]] {
        log(statement: statement, args: args)
        var result: [[String : AnyHashable]] = []
        try db?.forEachRow(statement: statement, doBindings: { stmt in
            try self.bindArgs(stmt: stmt, args: args)
        }, handleRow: { stmt, idx in
            var map:[String : AnyHashable] = [:]
            for i in 0..<stmt.columnCount() {
                var type = ColumnType(rawValue: Int(stmt.columnType(position: i))) ?? .null
                let columnName = stmt.columnName(position: i)
                if stmt.columnDeclType(position: i).lowercased() == "bit" {
                    type = .boolean
                }
                //print("\(columnName) = \(stmt.columnDeclType(position: i))")
                switch type {
                case .int:
                    map[columnName] = stmt.columnInt64(position: i)
                case .text:
                    map[columnName] = stmt.columnText(position: i)
                case .boolean:
                    map[columnName] = stmt.columnInt(position: i) > 0
                case .null:
                    break
                }
            }
            result.append(map)
        })
        return result
    }
    
    func log(statement: String, args: [Any]) {
        #if DEBUG
        var sql = statement
        for (index, item) in args.enumerated() {
            if item is String {
                sql = sql.stringByReplacing(string: ":\(index+1)", withString: "'\(item)'")
            } else {                
                sql = sql.stringByReplacing(string: ":\(index+1)", withString: "'\(item)'")
            }
        }
        print("\(#function) `\(sql)`".white)
        #endif
    }
    
    func bindArgs(stmt: SQLiteStmt, args: [Any?]) throws {
        for (index, item) in args.enumerated() {
            if item is String {
                try stmt.bind(position: index+1, item as! String)
            } else if item is Int64 {
                try stmt.bind(position: index+1, item as! Int64)
            } else if item is Int32 {
                try stmt.bind(position: index+1, item as! Int32)
            } else if item is Int {
                try stmt.bind(position: index+1, item as! Int)
            } else if item is Bool {
                try stmt.bind(position: index+1, item as! Bool ? 1:0)
            } else if item == nil {
                try stmt.bindNull(position: index+1)
            } else {
                assert(false)
            }
        }
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
