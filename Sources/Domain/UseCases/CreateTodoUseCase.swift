import Foundation

public struct CreateTodoUseCase {
    
    // MARK: - Properties
    
    private let repository: TodoRepository
    
    // MARK: - Initializer(s)
    
    public init(repository: TodoRepository) {
        self.repository = repository
    }
    
    // MARK: - Public Method(s)
    
    public func create(_ entity: CreateTodoEntity) async throws -> TodoEntity {
        guard !entity.title.isEmpty else { throw DomainError.validation("title cannot be empty") }
        
        return try await repository.create(entity)
    }
}
