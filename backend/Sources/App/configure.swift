//
//  File.swift
//  
//
//  Created by Rake Yang on 2021/11/18.
//

import Foundation
import Vapor


public func startServe() throws {
    LogDebug("\(CommandLine.arguments)")
    //ServerArgument.main()

    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)
    let app = Application(env)
    app.http.server.configuration.hostname = Environment.get("host") ?? "127.0.0.1"
    app.http.server.configuration.port = Int(Environment.get("port") ?? "") ?? 9001
    defer { app.shutdown() }
    try configure(app)
    try app.run()
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    //app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    app.sessions.use(.memory)
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(ContentFilter())
}
