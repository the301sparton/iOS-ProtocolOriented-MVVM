//
//  BreedDetailViewController.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 13/10/22.
//

import UIKit
import Combine
import Cosmos
import FlagKit

class BreedDetailViewController: UIViewController {
    
    @IBOutlet weak var originFlagImageView: UIImageView!
    @IBOutlet weak var breedHealth: CosmosView!
    @IBOutlet weak var breedIntelligence: CosmosView!
    @IBOutlet weak var breedFriendliness: CosmosView!
    @IBOutlet weak var breedAdaptability: CosmosView!
    @IBOutlet weak var infoHolderView: UIView!
    @IBOutlet weak var breedDesc: UILabel!
    @IBOutlet weak var breenOrigin: UILabel!
    @IBOutlet weak var breedWeight: UILabel!
    @IBOutlet weak var breedTemprament: UILabel!
    @IBOutlet weak var breedAge: UILabel!
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private var cancellable: AnyCancellable?
    public var catBreed: CatBreed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let catBreed = catBreed else { return }
        setupUI(catBreed: catBreed)
    }
    
    convenience init(catBreed: CatBreed){
        self.init()
        self.catBreed = catBreed
    }
}

// MARK: - BreedDetailViewController+Private
extension BreedDetailViewController {
    private func setupUI(catBreed: CatBreed) {
        cancellable = CommonFunctions.loadImage(for: catBreed).sink { [unowned self] image in imageView.image = image }
        infoHolderView.clipsToBounds = true
        infoHolderView.layer.cornerRadius = 12
        breedName.text = catBreed.name
        breedTemprament.text = catBreed.temperament
        breedDesc.text = catBreed.description
        breedAge.text = catBreed.lifeSpan
        breedWeight.text = "\(catBreed.weight.metric) KG"
        breenOrigin.text = catBreed.origin
        breedAdaptability.rating = Double(catBreed.adaptability)
        breedHealth.rating = Double( 5 - catBreed.healthIssues)
        breedIntelligence.rating = Double(catBreed.intelligence)
        breedFriendliness.rating = Double(((catBreed.catFriendly ?? 0) + catBreed.dogFriendly + catBreed.childFriendly + catBreed.strangerFriendly) / 4)
        var countryCode = catBreed.countryCode
        if countryCode == "SP" {
            countryCode = "SG"
        }
        if let flag = Flag(countryCode: countryCode) {
            originFlagImageView.image = flag.originalImage
        }
        let tapsRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleImageMode(_ :)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapsRecognizer)
    }
    
    @objc private func toggleImageMode(_ sender: UITapGestureRecognizer) {
        if imageView.contentMode == .scaleAspectFill {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
    }
}
