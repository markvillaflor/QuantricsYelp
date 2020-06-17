//
//  ServiceRequestManager.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/11/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import CoreLocation
import os.log

class ServiceRequestManager {
    private enum Constants {
        static let authorization = "Authorization"
    }
    
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask? = nil
    
    func businessSearchRequest(params: BusinessSearchParams, completion: @escaping (_ result: BusinessSearch?) -> Void) {
        guard let url = YelpEndpoint.businessSearch.createUrl(with: params) else {
            return completion(nil)
        }
        var request = URLRequest(url: url)
        request.addValue(YelpEndpoint.apiKey, forHTTPHeaderField: Constants.authorization)
        
        seviceRequest(request: request, responseType: BusinessSearch.self) { value in
            completion(value)
        }
    }
    
    func businessDetailsRequest(id: String?, completion: @escaping (_ result: BusinessDetails?) -> Void) {
        let params = BusinessDetailsParams(businessId: id)
        guard let url = YelpEndpoint.businessDetails.createUrl(with: params) else {
            return completion(nil)
        }
        var request = URLRequest(url: url)
        request.addValue(YelpEndpoint.apiKey, forHTTPHeaderField: Constants.authorization)
        
        seviceRequest(request: request, responseType: BusinessDetails.self) { value in
            completion(value)
        }
    }
    
    func businessReviewsRequest(id: String?, completion: @escaping (_ result: BusinessReviews?) -> Void) {
        let params = BusinessDetailsParams(businessId: id)
        guard let url = YelpEndpoint.reviews.createUrl(with: params) else {
            return completion(nil)
        }
        var request = URLRequest(url: url)
        request.addValue(YelpEndpoint.apiKey, forHTTPHeaderField: Constants.authorization)
        
        seviceRequest(request: request, responseType: BusinessReviews.self) { value in
            completion(value)
        }
    }
    
    private func seviceRequest<T: Decodable>(request: URLRequest, responseType: T.Type, completion: @escaping (_ result: T?) -> Void) {
        cleanDataTask()
        dataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data else {
                os_log("Response data is nil.")
                return completion(nil)
            }
            let result = try? JSONDecoder().decode(T.self, from: data)
            completion(result)
        })
        dataTask?.resume()
    }
    
    private func cleanDataTask() {
        if dataTask != nil {
            dataTask?.cancel()
            dataTask = nil
        }
    }
}
