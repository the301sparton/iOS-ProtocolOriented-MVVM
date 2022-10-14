//
//  CommonFunctions.swift
//  TheCatApp
//
//  Created by Chaitanya1 D on 14/10/22.
//

import UIKit
import Combine

struct CommonFunctions {
    static func loadImage(for catBreed: CatBreed) -> AnyPublisher<UIImage?, Never> {
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
