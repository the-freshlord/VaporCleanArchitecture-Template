import Data
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // register middlewares
    middlewares(app)

    try configure(app.databases, app.migrations, app.environment == .testing)
    setupRepositories(app)

    // register routes
    try routes(app)
}
