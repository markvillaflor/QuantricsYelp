//
//  BusinessListViewModel.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/14/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import CoreLocation
import UIKit

class BusinessListViewModel {
    private enum Constants: String {
        case sortResultsCopy = "Sort Results"
        case selectedCopy = "(selected)"
        case nearestCopy = "Nearest"
        case ratingsCopy = "Ratings"
        case cancelCopy = "Cancel"
        case locationAlertTitleCopy = "Please Enable Location Services"
        case locationAlertMessageCopy = "Go to Settings > Privacy > Location Services"
        case locationAlertActionCopy = "Got it"
        case searchCopy = "Search"
    }
    
    var businesses: [Business]?
    var searchText = ""
    var sortOrder: SortOrder = .nearest
    var searchCategory: SearchCategory = .nameOrCuisine
    var userCoordinates: CLLocationCoordinate2D?
    let service = ServiceRequestManager()
    let searchController = UISearchController(searchResultsController: nil)
    var locationManager: CLLocationManager?
    var viewController: BusinessListViewController?
    
    func setUp(with viewController: BusinessListViewController) {
        self.viewController = viewController
        self.setUpLocationManager()
        self.setUpSearchController()
    }
    
    func businessNameFor(indexPath: IndexPath) -> String {
        return businesses?[indexPath.row].name ?? ""
    }
    
    func detailTextLabelFor(indexPath: IndexPath) -> String {
        switch sortOrder {
        case .nearest:
            let distance = businesses?[indexPath.row].distance ?? 0
            let distanceInKilometers = String(format: "%.2f km", (distance / 1000))
            return distanceInKilometers
        case .ratings:
            if let rating = businesses?[indexPath.row].rating {
                return "\(rating.description) ⭐️"
            } else {
                return ""
            }
        }
    }
    
    func businessFor(indexPath: IndexPath) -> Business? {
        return businesses?[indexPath.row]
    }
    
    func performSearchRequest(offset: Int = 0) {
        // TODO: Support using default location when location services are off
        let params = BusinessSearchParams(term: searchText,
                                          category: searchCategory,
                                          sortOrder: sortOrder,
                                          userCoordinates: userCoordinates,
                                          offset: offset)
        service.businessSearchRequest(params: params) { [weak self] value in
            guard let value = value,
                let businesses = value.businesses,
                businesses.count > 0,
                let self = self,
                let vc = self.viewController else {
                    return
            }
            if offset == 0 {
                self.businesses = businesses
            } else {
                self.businesses?.append(contentsOf: businesses)
            }
            vc.reloadTableData()
        }
    }
    
    func showSortAlertController() {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(title: Constants.sortResultsCopy.rawValue, message: nil, preferredStyle: .actionSheet)
        let selectedText = Constants.selectedCopy.rawValue
        alert.addAction(UIAlertAction(title: "\(Constants.nearestCopy.rawValue) \(sortOrder == .nearest ? selectedText : "")", style: .default, handler: { _ in
            self.didSelectSortOrder(.nearest)
        }))
        alert.addAction(UIAlertAction(title: "\(Constants.ratingsCopy.rawValue) \(sortOrder == .ratings ? selectedText : "")", style: .default, handler: { _ in
            self.didSelectSortOrder(.ratings)
        }))
        alert.addAction(UIAlertAction(title: Constants.cancelCopy.rawValue, style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    func locationDenied() {
        guard let viewController = viewController else {
            return
        }
        let alert = UIAlertController(title: Constants.locationAlertTitleCopy.rawValue, message: Constants.locationAlertMessageCopy.rawValue, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constants.locationAlertActionCopy.rawValue, style: .default))
        viewController.present(alert, animated: true)
    }
    
    
    // MARK: Private Functions
    
    private func didSelectSortOrder(_ order: SortOrder) {
        guard sortOrder != order,
            let viewController = viewController else {
            return
        }
        sortOrder = order
        viewController.sortButton.image = order.icon
        performSearchRequest()
    }
    
    private func setUpSearchController() {
        guard let viewController = viewController else {
            return
        }
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchCopy.rawValue
        searchController.searchBar.delegate = viewController
        searchController.searchBar.scopeButtonTitles = SearchCategory.allCases.map { $0.rawValue }
        viewController.navigationItem.searchController = searchController
        searchController.searchBar.returnKeyType = .default
        viewController.definesPresentationContext = true
    }
    
    private func setUpLocationManager() {
        guard let viewController = viewController else {
            return
        }
        locationManager = CLLocationManager()
        locationManager?.delegate = viewController
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == CLAuthorizationStatus.notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else {
            locationManager?.requestLocation()
        }
    }
}
