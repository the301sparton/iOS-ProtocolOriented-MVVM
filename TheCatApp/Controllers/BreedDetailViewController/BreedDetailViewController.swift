//
//  BreedDetailViewController.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 13/10/22.
//

import UIKit
import Combine

class BreedDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private var cancellable: AnyCancellable?
    public var catBreed: CatBreed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let catBreed = catBreed else { return }
        setupUI(catBreed: catBreed)
    }
}

// MARK: - BreedDetailViewController+Private
extension BreedDetailViewController {
    private func setupUI(catBreed: CatBreed) {
        cancellable = CommonFunctions.loadImage(for: catBreed).sink { [unowned self] image in imageView.image = image }
        navigationItem.title = catBreed.name
    }
}
