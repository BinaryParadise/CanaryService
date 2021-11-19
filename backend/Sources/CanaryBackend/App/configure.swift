//
//  File.swift
//  
//
//  Created by Rake Yang on 2021/11/18.
//

import Foundation
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    app.sessions.use(.memory)
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(ContentFilter())
}
