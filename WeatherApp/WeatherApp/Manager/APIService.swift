//
//  APIService.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 18/09/23.
//

import Foundation

enum Constants {
    static let baseURL = "https://api.weatherapi.com/v1"
    static let API_KEY = "47096294b48b43ee896155647203009"
}

enum APIError: Error {
    case InvalidURL
    case UnableToFetchData
    case UnableToDecode
    case ResultNil
}

class APIService {
    private static let sharedObject: APIService? = nil
    
    private init() {}
    
    static func shared() -> APIService {
        if sharedObject == nil {
            return APIService()
        }
        return sharedObject!
    }
}

extension APIService {
    func fetchUserWeatherData(query: String, completion: @escaping(Result<CurrentLocation ,APIError>) -> Void) {
        let APIMethod = "/current.json"
        guard let url = URL(string: "\(Constants.baseURL)\(APIMethod)?key=\(Constants.API_KEY)&q=\(query)") else {
            completion(.failure(.InvalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
                  error == nil else {
                completion(.failure(.UnableToFetchData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CurrentLocation.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.UnableToFetchData))
            }
            
        }.resume()
    }
    
    func fetchCityWeatherData(cityName: String, completion: @escaping(Result<[SearchLocationData] ,APIError>) -> Void) {
        let APIMethod = "/search.json"
        guard let url = URL(string: "\(Constants.baseURL)\(APIMethod)?key=\(Constants.API_KEY)&q=\(cityName)") else {
            completion(.failure(.InvalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
                  error == nil else {
                completion(.failure(.UnableToFetchData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode([SearchLocationData].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(.UnableToFetchData))
            }
            
        }.resume()
    }
    
    func fetchForecastData(cityName: String?, numberOfDays: Int, completion: @escaping(Result<ForecastData ,APIError>) -> Void) {
        let APIMethod = "/forecast.json"
        guard let cityName = cityName,
              let url = URL(string: "\(Constants.baseURL)\(APIMethod)?key=\(Constants.API_KEY)&q=\(cityName)&days=\(numberOfDays)") else {
            completion(.failure(.InvalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
                  error == nil else {
                completion(.failure(.UnableToFetchData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(ForecastData.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(.UnableToFetchData))
            }
            
        }.resume()
    }
}
