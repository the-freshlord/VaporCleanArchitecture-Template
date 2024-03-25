@testable import Data
import Domain
import FluentSQLiteDriver
import XCTest
import XCTVapor

// MARK: - Application

private extension Application {
    static func makeTestable() async throws -> Application {
        let app = Application(.testing)
        app.databases.use(.sqlite(.memory), as: .sqlite)
        app.migrations.add(Todo.Create())
        
        try await app.autoMigrate()
        
        return app
    }
}

// MARK: - Request

private extension Request {
    convenience init(application: Application) {
        let eventLoop = application.eventLoopGroup.any()
        
        self.init(application: application, on: eventLoop)
    }
}

// MARK: - SUT

private typealias SUT = DatabaseTodoRepository

// MARK: - DatabaseTodoRepositoryTests

final class DatabaseTodoRepositoryTests: XCTestCase {
    
    // MARK: - Test(s)
    
    func testCreate() async throws {
        // Given
        let app = try await Application.makeTestable()
        defer { app.shutdown() }
        let sut = SUT(.init(application: app))
        
        // When
        let entity = try await sut.create(CreateTodoEntity(title: "Hello World"))
        
        // Then
        XCTAssertEqual(entity.title, "Hello World")
        XCTAssertFalse(entity.id.uuidString.isEmpty)
    }
    
    func testRead() async throws {
        // Given
        let app = try await Application.makeTestable()
        defer { app.shutdown() }
        let sut = SUT(.init(application: app))
        
        let entity1 = try await sut.create(CreateTodoEntity(title: "Hello World"))
        let entity2 = try await sut.create(CreateTodoEntity(title: "Hello World2"))
        
        // When
        let entities = try await sut.read()
        
        // Then
        XCTAssertEqual(entities.count, 2)
        XCTAssertEqual(entities[0].id, entity1.id)
        XCTAssertEqual(entities[1].id, entity2.id)
    }
    
    func testReadId() async throws {
        // Given
        let app = try await Application.makeTestable()
        defer { app.shutdown() }
        let sut = SUT(.init(application: app))
        
        let entity1 = try await sut.create(CreateTodoEntity(title: "Hello World"))
        
        // When
        let savedEntity = try await sut.read(id: entity1.id)
        
        // Then
        XCTAssertEqual(savedEntity.id, entity1.id)
        XCTAssertEqual(savedEntity.title, entity1.title)
    }
    
    func testDelete() async throws {
        // Given
        let app = try await Application.makeTestable()
        defer { app.shutdown() }
        let sut = SUT(.init(application: app))
        
        let entity1 = try await sut.create(CreateTodoEntity(title: "Hello World"))
        
        // When
        try await sut.delete(id: entity1.id)
        
        let entities = try await sut.read()
        
        // Then
        XCTAssertTrue(entities.isEmpty)
    }
}
