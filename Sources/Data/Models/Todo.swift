import Domain
import Fluent

// MARK: - Todo

final class Todo: Model {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

// MARK: - AsyncMigration

extension Todo {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("todos")
                .id()
                .field("title", .string, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("todos").delete()
        }
    }
}

// MARK: - EntityMappable

extension Todo: EntityMappable {
    var toEntity: TodoEntity {
        get throws {
            guard let id else { throw DomainError.somethingWrong("id is missing") }
            return TodoEntity(id: id, title: title)
        }
    }
    
    convenience init(entity: TodoEntity) {
        self.init(id: entity.id, title: entity.title)
    }
}
