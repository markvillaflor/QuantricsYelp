//
//  YelpEndpoint.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import CoreLocation
import os.log

enum YelpEndpoint: String {
    case businessSearch = "/v3/businesses/search"
    case businessDetails = "/v3/businesses/{id}"
    case reviews = "/v3/businesses/{id}/reviews"
    
    static let scheme = "https"
    static let host = "api.yelp.com"
    static let apiKey = "Bearer LyGVQe7JsPnn3FR9cl93NTB1m-sfloc_gZ1u2CI7rplogtf_qroq0P5zMGD7lj1aw_onKD_LtWUmB2196RO2CoNkcMpomHegzwmpje09IjM3CV5vCxaBOud7hMTgXnYx"
    
    func createUrl(with params: RequestParams) -> URL? {
        var url: URL?
        switch self {
        case .businessSearch:
            guard let params = params as? BusinessSearchParams else {
                os_log("Invalid params")
                return nil
            }
            var queryItems = [URLQueryItem]()
            if let term = params.term,
                !term.isEmpty,
                params.category == .nameOrCuisine {
                let queryItem = URLQueryItem(name: "term", value: term)
                queryItems.append(queryItem)
            }
            if let term = params.term,
                !term.isEmpty,
                params.category == .location {
                let queryItem = URLQueryItem(name: "location", value: term)
                queryItems.append(queryItem)
            } else {
                if let latitude = params.userCoordinates?.latitude.description,
                    let longitude = params.userCoordinates?.longitude.description {
                    let latitudeQueryItem = URLQueryItem(name: "latitude", value: latitude)
                    queryItems.append(latitudeQueryItem)
                    let longitudeQueryItem = URLQueryItem(name: "longitude", value: longitude)
                    queryItems.append(longitudeQueryItem)
                }
            }
            
            let offsetQueryItem = URLQueryItem(name: "offset", value: params.offset.description)
            queryItems.append(offsetQueryItem)
            let limitQueryItem = URLQueryItem(name: "limit", value: "20")
            queryItems.append(limitQueryItem)
            let sortOrderQueryItem = URLQueryItem(name: "sort_by", value: params.sortOrder.rawValue)
            queryItems.append(sortOrderQueryItem)
            
            var urlComponents = URLComponents()
            urlComponents.scheme = YelpEndpoint.scheme
            urlComponents.host = YelpEndpoint.host
            urlComponents.path = self.rawValue
            urlComponents.queryItems = queryItems
            url = urlComponents.url
        case .businessDetails:
            guard let params = params as? BusinessDetailsParams,
                let id = params.businessId else {
                os_log("Invalid params")
                return nil
            }
            var urlComponents = URLComponents()
            urlComponents.scheme = YelpEndpoint.scheme
            urlComponents.host = YelpEndpoint.host
            urlComponents.path = self.rawValue.replacingOccurrences(of: "{id}", with: id)
            url = urlComponents.url
        case .reviews:
            guard let params = params as? BusinessDetailsParams,
                let id = params.businessId else {
                os_log("Invalid params")
                return nil
            }
            var urlComponents = URLComponents()
            urlComponents.scheme = YelpEndpoint.scheme
            urlComponents.host = YelpEndpoint.host
            urlComponents.path = self.rawValue.replacingOccurrences(of: "{id}", with: id)
            url = urlComponents.url
        }
        return url
    }
}
