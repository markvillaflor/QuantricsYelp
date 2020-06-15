//
//  SortOrder.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import UIKit

enum SortOrder: String {
    case nearest = "distance"
    case ratings = "rating"
    
    var icon: UIImage? {
        switch self {
        case .nearest:
            return UIImage(named: "near-me-icon")
        case .ratings:
            return UIImage(named: "ratings-icon")
        }
    }
}
