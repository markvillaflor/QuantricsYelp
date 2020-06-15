//
//  BusinessDetailViewModel.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import Foundation
import UIKit

class BusinessDetailViewModel {
    var model: BusinessDetails
    
    init(model: BusinessDetails) {
        self.model = model
    }
    
    var name: String {
        return model.name ?? ""
    }
    
    var imageUrl: String? {
        return model.image_url
    }
    
    var phone: String {
        guard let displayPhone = model.display_phone,
            !displayPhone.isEmpty else {
            return "Phone: No Information"
        }
        return "Phone: \(displayPhone)"
    }
    
    var category: String {
        guard let categories = model.categories else {
            return "Category: No Information"
        }
        let categoriesString = categories.map { $0.title ?? "" }.joined(separator: ", ")
        return "Category: \(categoriesString)"
    }
    
    var location: String {
        guard let modelLocation = model.location,
            let displayAddress = modelLocation.display_address,
            !displayAddress.isEmpty else {
            return "Location: No Information"
        }
        return "Location: \(displayAddress.joined(separator: ", "))"
    }
    
    var rating: String {
        guard let modelRating = model.rating else {
            return "Rating: No Information"
        }
        return "Rating: \(modelRating.description)"
    }
    
    var viewController: BusinessDetailViewController?
    
    func setUp(with viewController: BusinessDetailViewController) {
        self.viewController = viewController
    }
    
    func setUpStackView() {
        guard let viewController = viewController else {
            return
        }
        DispatchQueue.main.async {
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.category))
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.rating))
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.location))
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.phone))
        }
    }
    
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        return label
    }
}
