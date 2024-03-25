import Domain
import Vapor

func middlewares(_ app: Application) {
    app.middleware = .init()
    app.middleware.use(RouteLoggingMiddleware(logLevel: .info))
    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}
