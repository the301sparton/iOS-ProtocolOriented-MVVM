//
//  CatService.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 11/10/22.
//

import Foundation
import UIKit

protocol CatServiceable {
    func getAllBreeds() async -> Result<CatBreeds, RequestError>
}

struct CatService: HTTPClient, CatServiceable {
    func getAllBreeds() async -> Result<CatBreeds, RequestError> {
        return await sendRequest(endpoint: CatEndpoint.getCatBreeds, responseModel: CatBreeds.self)
    }
}
