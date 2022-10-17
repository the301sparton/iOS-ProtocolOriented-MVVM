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
    private var resultSearchController = UISearchController()
    private var animationView: LottieAnimationView?
    private var catBreeds: CatBreeds?
    private var viewModel: BreedListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BreedListViewModel(service: CatService())
        viewModel?.delegate = self
        setupViews()
        setupSearchBar()
        viewModel?.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let detailsVC = segue.destination as? BreedDetailViewController
            let selectedShape = catBreeds?[indexPath.row]
            guard let selectedShape = selectedShape, let detailsVC = detailsVC else { return }
            detailsVC.catBreed = selectedShape
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
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
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        let breedNib = UINib(nibName: "BreedTableViewCell", bundle: Bundle.main)
        tableView.register(breedNib, forCellReuseIdentifier: "com.chai.breedCell")
        let animation = LottieAnimation.named("cat-loader")
        animationView = LottieAnimationView(animation: animation)
        guard let animationView = animationView else { return }
        animationView.loopMode = .loop
        animationView.play()
        animationView.frame = CGRect(x: view.bounds.midX - 150, y: view.bounds.midY - 150, width: 300, height: 300)
        view.addSubview(animationView)
    }
}

// MARK: - BreedListViewController+BreedListUpdateDelegate
extension BreedListViewController: BreedListUpdateDelegate {
    func tableViewDataUpdated(catBreeds: CatBreeds?) {
        animationView?.stop()
        self.catBreeds = catBreeds
        if let catBreedsList = catBreeds, !catBreedsList.isEmpty {
            self.animationView?.isHidden = true
            self.tableView.isHidden = false
        } else {
            let animation = LottieAnimation.named("cat-404")
            animationView?.animation = animation
            animationView?.play()
            self.animationView?.isHidden = false
            self.tableView.isHidden = true
        }
        self.tableView.reloadData()
    }
}

// MARK: - BreedListViewController+Search
extension BreedListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel?.applySearch(searchText: searchBar.text ?? "", selectedScope: selectedScope)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.applySearch(searchText: searchController.searchBar.text ?? "", selectedScope: searchController.searchBar.selectedScopeButtonIndex)
    }
}

// MARK: - BreedListViewController+TableView
extension BreedListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catBreeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let catbreeds = catBreeds else {
            return BreedTableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.chai.breedCell", for: indexPath) as! BreedTableViewCell
        cell.configure(with: catbreeds[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
