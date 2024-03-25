import Foundation

public protocol TodoRepository: Repository {
    func create(_ entity: CreateTodoEntity) async throws -> TodoEntity
    func read() async throws -> [TodoEntity]
    func read(id: UUID) async throws -> TodoEntity
    func delete(id: UUID) async throws
}
