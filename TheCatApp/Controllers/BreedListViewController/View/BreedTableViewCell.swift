//
//  BreedTableViewCell.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 11/10/22.
//

import UIKit
import Combine

class BreedTableViewCell: UITableViewCell {

    @IBOutlet weak var breedDesc: UILabel!
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var breedImage: UIImageView!
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?

   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override public func prepareForReuse() {
            super.prepareForReuse()
            breedImage.image = nil
            breedImage.alpha = 0.0
            animator?.stopAnimation(true)
            cancellable?.cancel()
        }

        public func configure(with catBreed: CatBreed?) {
            if let catBreed = catBreed {
                breedName.text = catBreed.name
                breedDesc.text = catBreed.description
                cancellable = loadImage(for: catBreed).sink { [unowned self] image in self.showImage(image: image) }
            }
        }
    
        

        private func showImage(image: UIImage?) {
            breedImage.alpha = 0.0
            animator?.stopAnimation(false)
            breedImage.image = image
            animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.breedImage.alpha = 1.0
            })
        }

        private func loadImage(for catBreed: CatBreed) -> AnyPublisher<UIImage?, Never> {
            return Just(catBreed.image?.url)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                if let url = URL(string: catBreed.image?.url ?? "") {
                    return ImageLoader.shared.loadImage(from: url)
                } else {
                     let url = URL(string: "https://img.freepik.com/premium-vector/cute-sad-cat-sitting-rain-cloud-cartoon-vector-icon-illustration-animal-nature-icon-isolated_138676-5215.jpg?w=1480")
                    return ImageLoader.shared.loadImage(from: url!)

                }
            })
            .eraseToAnyPublisher()
        }
    
}
