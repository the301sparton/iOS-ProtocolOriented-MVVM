//
//  BreedListViewModel.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 18/10/22.
//

import Foundation
class BreedListViewModel {
    private var catbreeds: CatBreeds?
    private var filteredCatBreeds: CatBreeds?
    private var service: CatServiceable?
    weak var delegate: BreedListUpdateDelegate?
    
    init(service: CatServiceable) {
        self.service = service 
    }
    
    func applySearch(searchText: String, selectedScope: Int) {
        filteredCatBreeds = catbreeds?.filter {
            (catBreed: CatBreed) -> Bool in
            let selectedFilter = Categories.allCases[selectedScope]
            var containsText = catBreed.name.lowercased().contains(searchText.lowercased())
            if searchText.count == 0 {
                containsText = true
            }
            switch selectedFilter {
            case .All:
                return true && containsText
            case .Natural:
                return catBreed.natural == 1 && containsText
            case .Hairless:
                return catBreed.hairless == 1 && containsText
            case .Allergic:
                return catBreed.hypoallergenic == 1 && containsText
            }
        }
        delegate?.tableViewDataUpdated(catBreeds: self.filteredCatBreeds)
    }
    
    func loadData() async {
        if let service = service {
            let result = await service.getAllBreeds()
            switch result {
            case .success(let catBreeds):
                self.catbreeds = catBreeds
                self.delegate?.tableViewDataUpdated(catBreeds: self.catbreeds)
            case .failure(let error):
                print(error)
            }
        }
    }
}

protocol BreedListUpdateDelegate: AnyObject {
    func tableViewDataUpdated(catBreeds: CatBreeds?)
}
