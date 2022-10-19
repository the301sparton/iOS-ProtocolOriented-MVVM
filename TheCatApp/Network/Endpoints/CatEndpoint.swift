//
//  CatService.swift
//  RequestApp
//
//  Created by Victor Catão on 18/02/22.
//

enum CatEndpoint {
    case topRated
}

extension CatEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topRated:
            return "/v1/breeds"
        }
    }

    var method: RequestMethod {
        switch self {
        case .topRated:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .topRated:
            return [
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .topRated:
            return nil
        }
    }
}
