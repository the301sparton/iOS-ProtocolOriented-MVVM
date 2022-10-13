//
//  ViewController.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 11/10/22.
//

import UIKit

class BreedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var catbreeds: CatBreeds?
    private var catBreadsWithCategory: CatBreeds?
    private var filteredCatBreeds: CatBreeds?
    private var resultSearchController = UISearchController()
    private var service: CatService?
    
    var isFiltering: Bool {
        return resultSearchController.isActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupTableView()
        setupSearchBar()
    }
    
    func setupSearchBar() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search Cat Breeds"
            controller.searchBar.delegate = self
            tableView.tableHeaderView = controller.searchBar
            definesPresentationContext = true
            controller.searchBar.scopeButtonTitles = Categories.allCases.map{$0.rawValue}
            return controller
        })()
    }
    
    func loadData() {
        self.service = CatService()
        if let service = service {
            Task(priority: .background) {
                let result = await service.getAllBreeds()
                switch result {
                case .success(let catBreeds):
                    self.catbreeds = catBreeds
                    tableView.reloadData()
                    print(catBreeds)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let breedNib = UINib(nibName: "BreedTableViewCell", bundle: Bundle.main)
        let filterNib = UINib(nibName: "FilterCell", bundle: Bundle.main)
        tableView.register(breedNib, forCellReuseIdentifier: "com.chai.breedCell")
        tableView.register(filterNib, forCellReuseIdentifier: "com.chai.filterCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return (filteredCatBreeds?.count ?? 0)
        } else {
            return (catbreeds?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let catbreeds = catbreeds else {
            return BreedTableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.chai.breedCell", for: indexPath) as! BreedTableViewCell
        
        if isFiltering {
            cell.configure(with: filteredCatBreeds?[indexPath.row])
        } else {
            cell.configure(with: catbreeds[indexPath.row ])
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        applySearch(searchText: searchBar.text ?? "", selectedScope: selectedScope)
    }
    
    func applySearch(searchText: String, selectedScope: Int) {
        filteredCatBreeds = catbreeds?.filter{
            (catBreed: CatBreed) -> Bool in
            let idx = Categories.allCases[selectedScope]
            var contain = catBreed.name.lowercased().contains(searchText.lowercased())
            if searchText.count == 0 {
                contain = true
            }
            switch idx {
            case .All:
                return true && contain
            case .Natural:
                return catBreed.natural == 1 && contain
            case .Hairless:
                return catBreed.hairless == 1 && contain
            case .Allergic:
                return catBreed.hypoallergenic == 1 && contain
            }
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        applySearch(searchText: searchController.searchBar.text ?? "", selectedScope: searchController.searchBar.selectedScopeButtonIndex)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else {
            return 140
        }
    }
    
}

enum Categories: String, CaseIterable {
        case  All,
              Natural,
              Hairless,
              Allergic
}

