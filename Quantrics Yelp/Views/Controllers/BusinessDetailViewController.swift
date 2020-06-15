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
    var viewModel = BusinessDetailViewModel(model: BusinessDetails())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = business?.name ?? ""
        service.businessDetailsRequest(id: business?.id) { [weak self] value in
            self?.setUpView(businessDetails: value)
        }
    }
    
    private func setUpView(businessDetails: BusinessDetails?) {
        guard let businessDetails = businessDetails else {
            return
        }
        viewModel = BusinessDetailViewModel(model: businessDetails)
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
