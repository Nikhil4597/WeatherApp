//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import Foundation
protocol HomeViewModelDelegate: AnyObject {
    func updateUI()
    func updateSearchResult(searchData: [SearchLocationData])
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    
    private var location: Location? = nil
    
    private var current: Current? = nil
}

// MARK: - Private methods
private extension HomeViewModel {
}

// MARK: - Public methods
extension HomeViewModel {
    func getUserWeatherData(query: String) {
        APIService.shared().fetchUserWeatherData(query: query) {[weak self] result in
            switch result {
            case .success(let result):
                self?.location = result.location
                self?.current = result.current
                self?.delegate?.updateUI()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getCityData(cityName: String) {
        APIService.shared().fetchCityWeatherData(cityName: cityName) {[weak self] result in
            switch result {
            case .success(let results):
                self?.delegate?.updateSearchResult(searchData: results)
            case.failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func currentLocationTitle() -> String {
        "\(location?.name ?? ""), \(location?.region ?? "")"
    }
    
    func countryLabel() -> String {
        location?.country ?? ""
    }
    
    func timeZone() -> String {
        location?.timezone ?? ""
    }
    
    func temperatureLabel() -> String {
        "\(current?.temperature ?? 0.0)"
    }
    
    func windSpeedLabel() -> String {
        "\(current?.windSpeed ?? 0.0)"
    }
    
    func humidityLabel() -> String {
        "\(current?.humidity ?? 0)"
    }
}
