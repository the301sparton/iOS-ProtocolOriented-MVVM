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
                let url = URL(string: "https://cdn.searchenginejournal.com/wp-content/uploads/2020/08/404-pages-sej-5f3ee7ff4966b-1520x800.png")
                return ImageLoader.shared.loadImage(from: url!)

            }
        })
        .eraseToAnyPublisher()
    }
}
