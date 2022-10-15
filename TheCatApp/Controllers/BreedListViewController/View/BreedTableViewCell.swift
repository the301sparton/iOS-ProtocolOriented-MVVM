//
//  BreedTableViewCell.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 11/10/22.
//

import UIKit
import FlagKit
import Combine

class BreedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var breedTemprament: UILabel!
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var breedDesc: UILabel!
    @IBOutlet weak var breedImage: UIImageView!
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        breedImage.image = nil
        breedImage.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
    
    private func showImage(image: UIImage?) {
        breedImage.alpha = 0.0
        animator?.stopAnimation(false)
        breedImage.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.breedImage.alpha = 1.0
        })
    }
    
    public func configure(with catBreed: CatBreed?) {
        if let catBreed = catBreed {
            var countryCode = catBreed.countryCode
            if countryCode == "SP" {
                countryCode = "SG"
            }
            if let flag = Flag(countryCode: countryCode) {
                flagImage.image = flag.originalImage
            }
            breedName.text = catBreed.name
            breedTemprament.text = catBreed.temperament
            breedDesc.text = catBreed.description
            cancellable = CommonFunctions.loadImage(for: catBreed).sink { [unowned self] image in showImage(image: image) }
        }
    }
}
