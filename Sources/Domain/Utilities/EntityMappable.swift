import Foundation

public protocol EntityMappable {
    associatedtype Entity
    
    var toEntity: Entity { get throws }
    
    init(entity: Entity)
}
