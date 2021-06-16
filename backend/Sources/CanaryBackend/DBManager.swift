//
//  DBManager.swift
//  
//
//  Created by Rake Yang on 2021/6/16.
//

import Foundation
import PerfectSQLite

class DBManager {
    static let shared = DBManager()
    var db: SQLite?
    init() {
        do {
            db = try SQLite(conf.sqlite)
            defer {
                db?.close()
            }
        } catch {
            print("\(error)".red)
        }
    }
    
    func query(statement: String, args: Any...) {
        do {
            try db?.execute(statement: statement, doBindings: { stmt in
                for (index, item) in args.enumerated() {
                    if let item = item as? String {
                        try? stmt.bind(position: index+1, item)
                    } else if let item = item as? Int64 {
                        try? stmt.bind(position: index+1, item)
                    }
                }
            })
        } catch {
            print("\(error)".red)
        }
    }
}
