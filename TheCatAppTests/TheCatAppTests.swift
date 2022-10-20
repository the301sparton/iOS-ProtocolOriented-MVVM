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
    var sut: BreedListViewModel!
    var delegate: MockBreedListUpdateDelegate!
    override func setUpWithError() throws {
        let bundle = Bundle(for: self.classForCoder)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        vc = storyBoard.instantiateViewController(withIdentifier: "BreedListViewController") as? BreedListViewController
        _ = vc.view
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        vc = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_BreedListLoadDataAndSearch() async {
        // When
        let serviceMock = CatsServiceMock()
        sut = BreedListViewModel(service: serviceMock)
        delegate = MockBreedListUpdateDelegate()
        sut.delegate = delegate
        await sut.loadData()
        // Then
        XCTAssertNotNil(delegate.catBreeds)
        sut.applySearch(searchText: "Ab", selectedScope: 0)
        XCTAssertEqual(delegate.catBreeds?.count ?? 0, 2)
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
     
}

final class CatsServiceMock: Mockable, CatServiceable {
    func getAllBreeds() async -> Result<CatBreeds, RequestError> {
        print("CatBreeds")
        return .success(loadJSON(filename: "CatBreeds", type: CatBreeds.self))
    }
}

final class MockBreedListUpdateDelegate: BreedListUpdateDelegate {
    var catBreeds: CatBreeds? = []
    func tableViewDataUpdated(catBreeds: CatBreeds?) {
        self.catBreeds = catBreeds
        print("count \(self.catBreeds?.count)")
    }
}


