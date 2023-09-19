//
//  ForecastDataModel.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import Foundation

struct ForecastData: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
}

struct Day: Codable {
    let maxTemp: Double
    let minTemp: Double
    let maxWind: Double
    
    enum CodingKeys: String, CodingKey {
        case maxTemp = "maxtemp_c"
        case minTemp = "mintemp_c"
        case maxWind = "maxwind_kph"
    }
}


