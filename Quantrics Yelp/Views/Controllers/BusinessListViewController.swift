//
//  BusinessListViewController.swift
//  Quantrics Yelp
//
//  Created by Mark Andrew Villaflor on 6/10/20.
//  Copyright © 2020 Mark Andrew Villaflor. All rights reserved.
//

import UIKit
import CoreLocation
import os.log

class BusinessListViewController: UIViewController {
    let viewModel = BusinessListViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setUp(with: self)
    }
    
    @IBAction func didTapSortButton(_ sender: Any) {
        viewModel.showSortAlertController()
    }
    
    func performSearchRequest(offset: Int = 0) {
        viewModel.performSearchRequest()
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension BusinessListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        performSearchRequest()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.searchCategory = SearchCategory.allCases[selectedScope]
        if !viewModel.searchText.isEmpty {
            performSearchRequest()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchText = ""
        performSearchRequest()
    }
}

extension BusinessListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = viewModel.businessNameFor(indexPath: indexPath)
        cell.detailTextLabel?.text = viewModel.detailTextLabelFor(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyBoard.instantiateViewController(identifier: "DetailViewController") as! BusinessDetailViewController
        detailViewController.business = viewModel.businessFor(indexPath: indexPath)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let businessesCount = viewModel.businesses?.count,
            businessesCount - 1 == indexPath.row {
            viewModel.performSearchRequest(offset: businessesCount)
        }
    }
}

extension BusinessListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("error: %@", "\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.userCoordinates = locations.first?.coordinate
        viewModel.performSearchRequest()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            viewModel.locationDenied()
        default:
            break
        }
    }
}

