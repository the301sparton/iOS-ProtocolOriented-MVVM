//
//  ViewController.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 11/10/22.
//

import UIKit
import Lottie

class BreedListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var catbreeds: CatBreeds?
    private var filteredCatBreeds: CatBreeds?
    private var resultSearchController = UISearchController()
    private var animationView: LottieAnimationView?
    private var service: CatService?
    var isFiltering: Bool {
        return resultSearchController.isActive
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        setupSearchBar()
    }
}

// MARK: - BreedListViewController+PrivateMethords
extension BreedListViewController {
    private func setupSearchBar() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.loadViewIfNeeded()
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.enablesReturnKeyAutomatically = false
            controller.searchBar.returnKeyType = .done
            controller.searchBar.placeholder = "Search Cat Breeds"
            controller.searchBar.delegate = self
            definesPresentationContext = true
            navigationItem.searchController = controller
            navigationItem.hidesSearchBarWhenScrolling = false
            controller.searchBar.scopeButtonTitles = Categories.allCases.map{$0.rawValue}
            return controller
        })()
    }
    
    private func loadData() {
        self.service = CatService()
        tableView.isHidden = true
        animationView?.play()
        if let service = service {
            Task(priority: .background) {
                let result = await service.getAllBreeds()
                switch result {
                case .success(let catBreeds):
                    self.catbreeds = catBreeds
                    tableView.reloadData()
                    animationView?.stop()
                    animationView?.isHidden = true
                    tableView.isHidden = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        let breedNib = UINib(nibName: "BreedTableViewCell", bundle: Bundle.main)
        tableView.register(breedNib, forCellReuseIdentifier: "com.chai.breedCell")
        let animation = LottieAnimation.named("cat-loader")
        animationView = LottieAnimationView(animation: animation)
        guard let animationView = animationView else { return }
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: view.bounds.midX - 150, y: view.bounds.midY - 150, width: 300, height: 300)
        view.addSubview(animationView)
    }
}

// MARK: - BreedListViewController+Search
extension BreedListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        applySearch(searchText: searchBar.text ?? "", selectedScope: selectedScope)
    }
    
    func applySearch(searchText: String, selectedScope: Int) {
        filteredCatBreeds = catbreeds?.filter{
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
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        applySearch(searchText: searchController.searchBar.text ?? "", selectedScope: searchController.searchBar.selectedScopeButtonIndex)
    }
}

// MARK: - BreedListViewController+TableView
extension BreedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: self)
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
        isFiltering ? cell.configure(with: filteredCatBreeds?[indexPath.row]) :             cell.configure(with: catbreeds[indexPath.row ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
