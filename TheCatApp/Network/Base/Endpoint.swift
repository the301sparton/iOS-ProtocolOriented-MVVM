//
//  RequestPath.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 11/10/22.
//

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.thecatapi.com"
    }
}
