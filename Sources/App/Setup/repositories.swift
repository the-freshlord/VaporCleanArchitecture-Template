import Data
import Domain
import Vapor

// MARK: - RepositoryId

struct RepositoryId: Hashable, Codable {
    let string: String
}

extension RepositoryId {
    static let todo = RepositoryId(string: "todo")
}

// MARK: - RepositoryFactory

final class RepositoryFactory {
    private var builders = [RepositoryId: (Request) -> Repository]()
    
    func make<R>(_ id: RepositoryId, _ request: Request) -> R {
        guard let builder = builders[id] else { fatalError("Repository builder for id `\(id.string)` is not configured.") }
        guard let repository = builder(request) as? R else { fatalError("Repository for id `\(id.string)` doesn't match expected type.") }
        return repository
    }
    
    func register(_ id: RepositoryId, _ builder: @escaping (Request) -> Repository) {
        builders[id] = builder
    }
}

// MARK: - Application

extension Application {
    private struct RepositoryFactoryKey: StorageKey {
        typealias Value = RepositoryFactory
    }
    
    var repositories: RepositoryFactory {
        if storage[RepositoryFactoryKey.self] == nil {
            storage[RepositoryFactoryKey.self] = .init()
        }
        guard let value = storage[RepositoryFactoryKey.self] else { fatalError("RepositoryFactory missing in storage.") }
        return value
    }
}

// MARK: - Setup

func setupRepositories(_ app: Application) {
    app.repositories.register(.todo) { DatabaseTodoRepository($0) }
}
