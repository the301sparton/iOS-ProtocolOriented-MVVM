//
//  TheCatAppTests.swift
//  TheCatAppTests
//
//  Created by Chaitanya1 D on 11/10/22.
//

import XCTest
@testable import TheCatApp

class TheCatAppTests: XCTestCase {
    func testCatServiceMock() async {
        let serviceMock = CatsServiceMock()
        let failingResult = await serviceMock.getAllBreeds()
        switch failingResult {
        case .success(let catBreeds):
            XCTAssert(catBreeds.count > 0)
        case .failure:
            XCTFail("The request should not fail")
        }
    }
}

final class CatsServiceMock: Mockable, CatServiceable {
    func getAllBreeds() async -> Result<CatBreeds, RequestError> {
        return .success(loadJSON(filename: "CatBreeds", type: CatBreeds.self))
    }
}


