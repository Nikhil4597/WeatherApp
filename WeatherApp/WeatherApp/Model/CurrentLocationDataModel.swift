//
//  ResponseData.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import Foundation

struct CurrentLocation: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case timezone = "tz_id"
    }
}

struct Current: Codable {
    let temperature: Float
    let windSpeed: Float
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case windSpeed = "wind_kph"
        case humidity
    }
}
