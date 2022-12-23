//
//  NetworkManager.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 08.12.2022.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    var cities: [String] { get }
    func getDataFromWheatherApi(completion: @escaping (([String: Double]) -> Void))
}

class NetworkManager: NetworkManagerProtocol {
    
    let cities = [
        "Warsaw",
        "Bucharest",
        "Budapest",
        "Munich",
        "Palermo",
        "Bremen",
        "Florence",
        "Valencia",
        "Netivot",
        "Karmie"
    ]
    
    var urls = [
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Warsaw&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Bucharest&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Budapest&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Munich&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Palermo&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Bremen&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Florence&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Valencia&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Netivot&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=b79e78fc915c4f8089a164434221712&q=Jermuk&days=7&aqi=no&alerts=no"
    ]
    
    func getDataFromWheatherApi(completion: @escaping (([String: Double]) -> Void)) {
        
        var currentTempOfCity: [String: Double] = [:]

        let dispatchGroup = DispatchGroup()
        
        for url in urls {
            dispatchGroup.enter()
            
            AF.request(url)
                .validate()
                .responseDecodable(of: Weather.self, emptyResponseCodes: [200, 204, 205]) { (response) in
                    switch response.result {
                    case .success(let data):
                        let weatherJson = data
//                        let city = weather.location?.name ?? ""
//                        let country = weather.location?.country ?? ""
//                        let currentTemp = weather.current?.tempC ?? 0
//                        print(country)
//                        print(city)
//                        print(currentTemp)
//
//                        currentTempOfCity[city] = currentTemp
//                        print(currentTempOfCity)
                        
                        let weather = self.modelJsonToModel(weatherJson)
                        
                        completion(weather)

                        dispatchGroup.leave()
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
    
    func modelJsonToModel(_ weatherJson: Weather?) -> WeatherLocale {
        return weatherLocale
    }
}


