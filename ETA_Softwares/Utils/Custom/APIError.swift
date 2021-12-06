 

import Foundation
enum APIError: Error {
    case NOInternet
    case ErrorWhileSending
    case NetworkError
    case customError(message:String)
}
extension APIError :LocalizedError {
    public mutating func errorDiscription()->String {
        switch self {
        case .customError(let error):
            return error
        case .NOInternet:
            return ErrorMessages.Network.noNetwork
        case .ErrorWhileSending:
            return ErrorMessages.error
        case .NetworkError:
            return ErrorMessages.Network.networkError
        }
    }
}
