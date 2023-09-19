//
//  ViewController.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 18/09/23.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
   private enum Constants {
       static let title = "Weather"
       static let alertTitle = "Location Permission"
       static let alertMessage = "Please enable location access for this app in settings."
       static let locationRequestTitle = "Allow"
       static let cancelTitle = "Cancel"
       static let searchBarPlaceholderText = "Search another cities"
       static let errorTitle = "Error:"
       
       // Constraint constants
       static let space = 5.0
    }
    
    private let viewModel:HomeViewModel = {
       let viewModel = HomeViewModel()
        return viewModel
    }()
    
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    private let tileView: TileView = {
        let view = TileView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchViewController())
        controller.searchBar.placeholder = Constants.searchBarPlaceholderText
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.showsSearchResultsButton = true
        controller.searchBar.showsBookmarkButton = true
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI View constraints
    private func setupUIConstraints() {
        /// Tile view constraints
        NSLayoutConstraint.activate([
            tileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.space),
            tileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.space),
            tileView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.space),
            tileView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.space)
        ])
    }
}

// MARK: - Private methods
private extension HomeViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupSearchBar()
        view.addSubview(tileView)
        viewModel.delegate = self
        
        setupLocation()
        setupUIConstraints()
    }
    
    func setupSearchBar() {
        navigationItem.title = Constants.title
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    func setupLocation() {
        locationAuthorizationIfNot()
        locationManager.delegate = self
        
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.startUpdatingLocation()
            } else {
                self?.locationAuthorizationIfNot()
            }
        }
    }
    
    func locationAuthorizationIfNot() {
        let status = locationManager.authorizationStatus
        if status != .authorizedWhenInUse {
            askForLocationPermission()
        }
    }
    
    func askForLocationPermission() {
        let alert = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)
        
        let locationRequestAction = UIAlertAction(title: Constants.locationRequestTitle, style: .default) {[weak self] _ in
            self?.locationManager.requestWhenInUseAuthorization()
        }
        
        let cancelAction = UIAlertAction(title: Constants.cancelTitle, style: .default)
        
        alert.addAction(locationRequestAction)
        alert.addAction(cancelAction)

        navigationController?.present(alert, animated: true)
    }
    
    func updateView() {
        let tileViewModel = TileViewModel(currentLocationLabel: viewModel.currentLocationTitle(),
          countryLabel: viewModel.countryLabel(),
          timezone: viewModel.timeZone(),
          temperatureLabel: viewModel.temperatureLabel(),
          windSpeedLabel: viewModel.windSpeedLabel(),
          humidity: viewModel.humidityLabel())
        
        tileView.updateView(viewModel: tileViewModel)
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let coordinates =  "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        viewModel.getUserWeatherData(query: coordinates)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(Constants.errorTitle) \(error.localizedDescription)")
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func updateUI() {
        DispatchQueue.main.async {[weak self] in
            self?.updateView()
        }
    }
    
    func updateSearchResult(searchData: [SearchLocationData]) {
        DispatchQueue.main.async {[weak self] in
            guard let searchViewController = self?.searchController.searchResultsController as? SearchViewController else {
                return
            }
            
            searchViewController.configure(results: searchData)
            searchViewController.delegate = self
        }
    }
}

// MARK: -
extension HomeViewController: UISearchBarDelegate, SearchViewDeleagte {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            viewModel.getCityData(cityName: query)
        }
    }
    
    func resultCellSelected(result: SearchLocationData) {
        let detailViewController = DetailViewController()
        detailViewController.configureCityData(cityName: result.name)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

