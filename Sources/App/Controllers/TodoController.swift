import Domain
import Vapor

// MARK: - TodoController

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: readAll)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.get(use: read)
            todo.delete(use: delete)
        }
    }

    func readAll(request: Request) async throws -> [TodoResponse] {
        try await request.repository.read().map(TodoResponse.init(entity:))
    }
    
    func create(request: Request) async throws -> TodoResponse {
        let entity = try request.content.decode(CreateTodoRequest.self).toEntity
        let useCase = CreateTodoUseCase(repository: request.repository)
        return TodoResponse(entity: try await useCase.create(entity))
    }
    
    func read(request: Request) async throws -> TodoResponse {
        guard let todoID: UUID = request.parameters.get("todoID") else { throw Abort(.badRequest, reason: "todoID required") }
        return TodoResponse(entity: try await request.repository.read(id: todoID))
    }

    func delete(request: Request) async throws -> HTTPStatus {
        guard let todoID: UUID = request.parameters.get("todoID") else { throw Abort(.badRequest, reason: "todoID required") }
        try await request.repository.delete(id: todoID)
        return .noContent
    }
}

// MARK: - Request

private extension Request {
    var repository: TodoRepository { application.repositories.make(.todo, self) }
}
