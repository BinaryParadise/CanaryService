import Vapor

func routes(_ app: Application) throws {
    var builder: RoutesBuilder
    if let context = Environment.get("context") {
        //统一前缀
        builder = app.grouped(.constant(context))
    } else {
        builder = app
    }
    try builder.register(collection: HomeController())
    try builder.register(collection: UserController())
    try builder.register(collection: ConfController())
    try builder.register(collection: ProjectController())
    try builder.register(collection: MockController())
    if #available(macOS 12, *) {
        try builder.register(collection: WebSocketController())
    }
}
