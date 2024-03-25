import Domain
import Vapor

// MARK: - TodoResponse

struct TodoResponse: Content {
    let id: UUID
    let title: String
}

// MARK: - EntityMappable

extension TodoResponse: EntityMappable {
    var toEntity: TodoEntity {
        TodoEntity(id: id, title: title)
    }
    
    init(entity: TodoEntity) {
        self.init(id: entity.id, title: entity.title)
    }
}
