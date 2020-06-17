//
//  BusinessDetailViewController.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/12/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UIViewController {

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    var business: Business? = nil
    let service = ServiceRequestManager()
    var viewModel = BusinessDetailViewModel(model: BusinessDetails(), reviews: BusinessReviews())
    private var businessDetails: BusinessDetails?
    private var businessReviews: BusinessReviews?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = business?.name ?? ""
        requestBusinessDetails()
    }
    
    @IBAction func didTapMaps(_ sender: Any) {
        viewModel.didTapMaps()
    }
    
    private func requestBusinessDetails() {
        service.businessDetailsRequest(id: business?.id) { [weak self] value in
            self?.businessDetails = value
            self?.requestBusinessReviews()
        }
    }
    
    private func requestBusinessReviews() {
        service.businessReviewsRequest(id: business?.id) { [weak self] value in
            self?.businessReviews = value
            self?.setUpView()
        }
    }
    
    private func setUpView() {
        guard let businessDetails = businessDetails,
            let businessReviews = businessReviews else {
            return
        }
        
        viewModel = BusinessDetailViewModel(model: businessDetails, reviews: businessReviews)
        viewModel.setUp(with: self)
        if let imageURLString = viewModel.imageUrl,
            !imageURLString.isEmpty {
            
            self.businessImage.downloaded(from: imageURLString, contentMode: .scaleAspectFill)
        } else {
            DispatchQueue.main.async {
                self.businessImage.image = UIImage(systemName: "photo")
            }
        }
        self.viewModel.setUpStackView()
    }
}
