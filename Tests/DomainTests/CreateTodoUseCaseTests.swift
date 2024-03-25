import Domain
import XCTest

// MARK: - MockRepository

private struct MockRepository: TodoRepository {
    
    // MARK: - Public Method(s)
    
    func create(_ entity: CreateTodoEntity) async throws -> TodoEntity {
        TodoEntity(id: UUID(), title: entity.title)
    }
    
    func read() async throws -> [TodoEntity] {
        []
    }
    
    func read(id: UUID) async throws -> TodoEntity {
        TodoEntity(id: id, title: "Hello World")
    }
    
    func delete(id: UUID) async throws {
        // not implemented
    }
}

// MARK: - CreateTodoUseCaseTests

final class CreateTodoUseCaseTests: XCTestCase {
    
    // MARK: - Test(s)
    
    func test_create_when_titleIsEmpty_then_throwsError() async throws {
        // Given
        let sut = CreateTodoUseCase(repository: MockRepository())
        
        // When
        var domainError: DomainError?
        
        do {
            _ = try await sut.create(.init(title: ""))
        } catch {
            domainError = error as? DomainError
        }
        
        // Then
        XCTAssertEqual(domainError, DomainError.validation("title cannot be empty"))
    }
    
    func test_create_when_RequiredFieldsAreValid_then_createsEntity() async throws {
        // Given
        let sut = CreateTodoUseCase(repository: MockRepository())
        
        // When
        let entity = try await sut.create(.init(title: "Hello World"))
        
        // Then
        XCTAssertEqual(entity.title, "Hello World")
    }
}
