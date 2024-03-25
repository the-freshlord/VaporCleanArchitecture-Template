@testable import App
import XCTVapor

// MARK: - Application

private extension Application {
    static func makeTestable() async throws -> Application {
        let app = Application(.testing)
        
        try await configure(app)
        try await app.autoRevert()
        try await app.autoMigrate()
        
        return app
    }
}

// MARK: - AppTests

final class AppTests: XCTestCase {
    
    // MARK: - Test(s)
    
    func testHelloWorld() async throws {
        let app = try await Application.makeTestable()
        defer { app.shutdown() }

        try app.test(.GET, "hello") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.body.string, "Hello, world!")
        }
    }
    
    func testCreate() async throws {
        let app = try await Application.makeTestable()
        defer { app.shutdown() }
        
        try app.test(.POST, "todos") { request in
            try request.content.encode(["title": "Test"])
        } afterResponse: { response in
            let todo = try response.content.decode(TodoResponse.self)
            XCTAssertEqual(todo.title, "Test")
        }
    }
}
