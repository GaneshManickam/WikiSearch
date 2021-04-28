//
//  ErrorResponse.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Foundation
import Mapper

struct ErrorResponse: Mappable {
    var error: ErrorResponseData?

    init(map: Mapper) throws {
        error = map.optionalFrom("error")
    }
}

struct ErrorResponseData: Mappable {
    var status: Int?
    var message: String?
    var reason: String?

    init(map: Mapper) throws {
        status = map.optionalFrom("status") ?? 400
        message = map.optionalFrom("message") ?? ""
        reason = map.optionalFrom("reason") ?? ""
    }
}
