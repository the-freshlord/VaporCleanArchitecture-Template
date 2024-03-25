import Fluent
import FluentPostgresDriver
import Foundation
import NIOSSL

public func configure(_ databases: Databases, _ migrations: Migrations, _ isTesting: Bool = false) throws {
    let port = isTesting ? 5433 : SQLPostgresConfiguration.ianaPortNumber
    let database = isTesting ? "vapor-test" : "vapor_database"
    
    databases.use(
        DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: ProcessInfo.processInfo.environment["DATABASE_HOST"] ?? "localhost",
                port: ProcessInfo.processInfo.environment["DATABASE_PORT"].flatMap(Int.init(_:)) ?? port,
                username: ProcessInfo.processInfo.environment["DATABASE_USERNAME"] ?? "vapor_username",
                password: ProcessInfo.processInfo.environment["DATABASE_PASSWORD"] ?? "vapor_password",
                database: ProcessInfo.processInfo.environment["DATABASE_NAME"] ?? database,
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )
    
    migrations.add(Todo.Create())
}
