import Domain
import Vapor

extension DomainError: AbortError {
    public var status: HTTPResponseStatus {
        switch self {
        case .validation:
            return .badRequest
        case .somethingWrong:
            return .internalServerError
        }
    }
    
    public var reason: String {
        switch self {
        case let .validation(error):
            return error
        case let .somethingWrong(error):
            return error
        }
    }
}
