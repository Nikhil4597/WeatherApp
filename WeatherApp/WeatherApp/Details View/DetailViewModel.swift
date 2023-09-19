//
//  DetailsViewModel.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import Foundation
protocol DetailViewModelDelegate: AnyObject {
    func updateTileView()
    func updateTableView()
}

class DetailViewModel {
    enum Constant {
        static let numberOfDays = 3
        
    }
    weak var delegate: DetailViewModelDelegate?
    
    var cityName: String? = nil
    
    var locationData: Location? = nil {
        didSet {
            updateIfNeeded()
        }
    }
    
    var currentData: Current? = nil {
        didSet {
            updateIfNeeded()
        }
    }
    
    private var forecastData: Forecast? = nil {
        didSet {
            delegate?.updateTableView()
        }
    }
}

// MARK: - Public methods
extension DetailViewModel {
    func getForecastData() {
        APIService.shared().fetchForecastData(cityName: cityName, numberOfDays: Constant.numberOfDays) {[weak self] result in
            switch result {
            case .success(let forecast):
                self?.forecastData = forecast.forecast
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }
    
    func getUserWeatherData() {
        APIService.shared().fetchUserWeatherData(query: cityName ?? "") {[weak self] result in
            switch result {
            case .success(let result):
                self?.locationData = result.location
                self?.currentData = result.current
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func numberOfSection() -> Int {
        1
    }
    
    func numberOfCellInSection() -> Int {
        forecastData?.forecastday.count ?? 0
    }
    
    func forecastData(at index: Int) -> ForecastDay? {
        forecastData?.forecastday[index]
    }
}

// MARK: - Private methods
private extension DetailViewModel {
    func updateIfNeeded() {
        if locationData != nil,
           currentData != nil {
            delegate?.updateTileView()
        }
    }
}
