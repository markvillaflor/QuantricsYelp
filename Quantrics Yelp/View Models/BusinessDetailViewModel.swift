//
//  BusinessDetailViewModel.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class BusinessDetailViewModel {
    var model: BusinessDetails
    var reviews: BusinessReviews
    
    init(model: BusinessDetails, reviews: BusinessReviews) {
        self.model = model
        self.reviews = reviews
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
        guard let viewController = viewController, let reviews = reviews.reviews else {
            return
        }
        DispatchQueue.main.async {
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.category))
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.rating))
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.location))
            viewController.stackView.addArrangedSubview(self.createLabel(with: self.phone))
            
            for review in reviews {
                let reviewCardView = ReviewCardView(frame: CGRect(x: 0, y: 0, width: 400, height: 55))
                reviewCardView.translatesAutoresizingMaskIntoConstraints = false
                reviewCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: reviewCardView.frame.height).isActive = true
                reviewCardView.widthAnchor.constraint(equalToConstant: reviewCardView.frame.width).isActive = true
                
                reviewCardView.nameLabel.text = review.user?.name
                
                if let imageUrl = review.user?.image_url {
                    reviewCardView.userImage.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
                } else {
                    reviewCardView.userImage.image = UIImage(systemName: "person.crop.square")
                }
                
                reviewCardView.reviewDescription.text = review.text
                viewController.stackView.addArrangedSubview(reviewCardView)
            }
        }
        
    }
    
    func didTapMaps() {
        guard let latitude = model.coordinates?.latitude,
            let longitude = model.coordinates?.longitude,
            let latitudeCoordinate: CLLocationDegrees = CLLocationDegrees(exactly: latitude),
            let longitudeCoordinate: CLLocationDegrees = CLLocationDegrees(exactly: longitude) else {
            return
        }
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitudeCoordinate, longitudeCoordinate)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }
}
