//
//  TheCatAppTests.swift
//  TheCatAppTests
//
//  Created by Chaitanya1 D on 11/10/22.
//

import XCTest
@testable import TheCatApp

class TheCatAppTests: XCTestCase {
    
    var vc: BreedListViewController!
    override func setUp() {
        let bundle = Bundle(for: self.classForCoder)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        vc = storyBoard.instantiateViewController(withIdentifier: "BreedListViewController") as? BreedListViewController
        _ = vc.view
    }
    
    func test_BreedListTableViewNotNil() {
        XCTAssertNotNil(vc.tableView)
    }
    
    func test_BreedListTableViewDataSource() {
        XCTAssertTrue(vc.tableView.dataSource is BreedListViewController)
    }
    
    func test_BreedListTableViewDelegate() {
        XCTAssertTrue(vc.tableView.delegate is BreedListViewController)
    }
    
    func test_BreedListTableViewSameInstance() {
        XCTAssertEqual(vc.tableView.delegate as! BreedListViewController, vc.tableView.dataSource as! BreedListViewController )
    }
     
    func test_CatServiceMock() async {
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


