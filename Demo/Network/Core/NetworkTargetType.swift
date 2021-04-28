//
//  NetworkTargetType.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Moya

public protocol NetworkTargetType: TargetType {
    var httpHeader: [String: String] { get }
    var sampleResponseClosure: () -> EndpointSampleResponse { get }
}

public extension NetworkTargetType {
    var sampleResponseClosure: () -> EndpointSampleResponse {
        return { EndpointSampleResponse.networkResponse(200, self.sampleData) }
    }

    var httpHeader: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    var sampleData: Data {
        return Data()
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var parameters: [String: Any]? {
        return [:]
    }

    var baseURL: URL {
        return URL(string: Constants.URLs.base_url)!
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return Task.requestParameters(parameters: parameters!, encoding: JSONEncoding.default)
    }
}
