//
//  BusinessSearchParams.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import CoreLocation

struct BusinessSearchParams: RequestParams {
    var term: String?
    var category: SearchCategory
    var sortOrder: SortOrder
    var userCoordinates: CLLocationCoordinate2D?
    var offset: Int
}
