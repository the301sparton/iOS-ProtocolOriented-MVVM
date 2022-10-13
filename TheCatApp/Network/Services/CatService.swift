//
//  MoviesService.swift
//  RequestApp
//
//  Created by Victor Catão on 18/02/22.
//

import Foundation
import UIKit

protocol CatServiceable {
    func getAllBreeds() async -> Result<CatBreeds, RequestError>
}

struct CatService: HTTPClient, CatServiceable {
    func getAllBreeds() async -> Result<CatBreeds, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.topRated, responseModel: CatBreeds.self)
    }
}
