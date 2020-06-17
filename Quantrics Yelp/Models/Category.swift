//
//  Category.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

struct Category: Decodable {
    var title: String?
}

// new models

struct BusinessReviews: Decodable {
    var reviews: [Review]?
}

struct Review: Decodable {
    var rating: Float?
    var text: String?
    var user: User?
}

struct User: Decodable {
    var image_url: String?
    var name: String?
}
