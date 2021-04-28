//
//  NetworkError.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Foundation
import Moya

public enum NetworkError: Swift.Error {
    /// Indicates unknown error
    case unknownError(message: String)

    /// Indicates time out error
    case timeOut
}

func checkFailureError(_ error: Error) -> NetworkError {
    switch error.localizedDescription.lowercased() {
    case "the request timed out.":
        return .timeOut
    default:
        return .unknownError(message: error.localizedDescription)
    }
}

extension Swift.Error {
    var code: Int { return (self as NSError).code }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .unknownError(message):
            return message
        case .timeOut:
            return "The request timed out."
        }
    }
}
