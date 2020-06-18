//
//  BusinessDetails.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

struct BusinessDetails: Decodable {
    var name: String?
    var image_url: String?
    var categories: [Category]?
    var rating: Float?
    var location: Location?
    var display_phone: String?
    var coordinates: Coordinates?
}
