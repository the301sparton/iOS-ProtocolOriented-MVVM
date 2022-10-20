//
//  CatService.swift
//  RequestApp
//
//  Created by Victor Catão on 18/02/22.
//

enum CatEndpoint {
    case getCatBreeds
}

extension CatEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getCatBreeds:
            return "/v1/breeds"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getCatBreeds:
            return .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .getCatBreeds:
            return [
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .getCatBreeds:
            return nil
        }
    }
}
