//
//  Review.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/18/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

struct Review: Decodable {
    var rating: Float?
    var text: String?
    var user: User?
}
