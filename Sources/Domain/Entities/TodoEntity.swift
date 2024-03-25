import Foundation

public struct TodoEntity {
    
    // MARK: - Properties
    
    public let id: UUID
    public let title: String
    
    // MARK: - Initializer(s)
    
    public init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}
