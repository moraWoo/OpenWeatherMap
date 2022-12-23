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
    func getDataFromWheatherApiWithoutCoodinates(completion: @escaping ((WeatherLocale) -> Void))
    func getDataFromWheatherApiWithCoordinates(url: String?, completion: @escaping ((WeatherLocale) -> Void))
}

class NetworkManager: NetworkManagerProtocol {
    
    var presenter: MainViewPresenterProtocol?

    let cities = [
        "My Location",
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
    var forecastHourly: [ForecastHourLocale] = []
    var forecastWeekly: [ForecastWeeklyLocale] = []
    var citiesWithInfo: [City] = []
    var coordinates: String?
    let dispatchGroup = DispatchGroup()

    var urls = [
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Warsaw&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Bucharest&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Budapest&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Munich&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Palermo&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Bremen&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Florence&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Valencia&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Netivot&days=7&aqi=no&alerts=no",
        "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=Jermuk&days=7&aqi=no&alerts=no"
    ]
        
    func getDataFromWheatherApiWithoutCoodinates(completion: @escaping ((WeatherLocale) -> Void)) {
        for url in urls {
            dispatchGroup.enter()
            
            AF.request(url)
                .validate()
                .responseDecodable(of: Weather.self, emptyResponseCodes: [200, 204, 205]) { (response) in
                    switch response.result {
                    case .success(let weatherJson):
                        let weather = self.modelJsonToModel(fromStatic: true, weatherJson)
                        completion(weather)
                        self.dispatchGroup.leave()
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
    
    func getDataFromWheatherApiWithCoordinates(url: String?, completion: @escaping ((WeatherLocale) -> Void)) {
        dispatchGroup.enter()

        guard let urlURL = URL(string: url ?? "") else { return }

        AF.request(urlURL)
            .responseDecodable(of: Weather.self, emptyResponseCodes: [200, 204, 205]) { (response) in
                switch response.result {
                case .success(let weatherJson):
                    let weather = self.modelJsonToModel(fromStatic: false, weatherJson)
                    completion(weather)
                    self.dispatchGroup.leave()
                case .failure(let error):
                    print(error)
                }
            }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.global().async {
                print("Finished2")
                print("notify2: \(self.presenter?.coordinates)")
            }
        }
    }
    
    func modelJsonToModel(fromStatic: Bool, _ weatherJson: Weather?) -> WeatherLocale {
        
        let forecastDayDataTemp = weatherJson?.forecast?.forecastday?[0].hour?.filter({$0.tempC != nil}).map({$0.tempC})
        let forecastDayDataEpoch = weatherJson?.forecast?.forecastday?[0].hour?.filter({$0.timeEpoch != nil}).map({$0.timeEpoch})
        let forecastDayDataConditionCode = weatherJson?.forecast?.forecastday?[0].hour?.filter({$0.condition?.code != nil}).map({$0.condition?.code})
        
        for i in 0 ..< (forecastDayDataTemp?.count ?? 0) {
            forecastHourly.append(ForecastHourLocale(
                avgtempC: forecastDayDataTemp?[i],
                timeEpoch: forecastDayDataEpoch?[i],
                conditionCode: forecastDayDataConditionCode?[i]
            ))
        }
        
        let forecastWeeklyDate = weatherJson?.forecast?.forecastday?.filter({$0.day != nil}).map({$0.date})

        for i in 0 ..< (forecastWeeklyDate?.count ?? 0) {
            let forecastWeeklyMaxTemp = weatherJson?
                .forecast?
                .forecastday?[i]
                .day?
                .maxtempC
            let forecastWeeklyMinTemp = weatherJson?
                .forecast?
                .forecastday?[i]
                .day?
                .mintempC
            let forecastWeeklyHumidity = weatherJson?
                .forecast?
                .forecastday?[i]
                .day?
                .avghumidity
            let forecastWeeklyCondCode = weatherJson?
                .forecast?
                .forecastday?[i]
                .day?
                .condition?
                .code
            forecastWeekly.append(ForecastWeeklyLocale(
                date: forecastWeeklyDate?[i],
                maxtempC: forecastWeeklyMaxTemp,
                mintempC: forecastWeeklyMinTemp,
                avghumidity: forecastWeeklyHumidity,
                conditionCode: forecastWeeklyCondCode
            ))
        }
                
        let city = City(
            city: weatherJson?.location?.name,
            myLocation: 10,
            lastUpdated: weatherJson?.current?.lastUpdatedEpoch,
            tempC: weatherJson?.current?.tempC,
            hTemp: weatherJson?.forecast?.forecastday?[0].day?.maxtempC,
            lTemp: weatherJson?.forecast?.forecastday?[0].day?.mintempC,
            sunrise: weatherJson?.forecast?.forecastday?[0].astro?.sunrise,
            sunset: weatherJson?.forecast?.forecastday?[0].astro?.sunset,
            chanceOfRain: weatherJson?.forecast?.forecastday?[0].day?.dailyChanceOfRain,
            humidity: weatherJson?.current?.humidity,
            windKph: weatherJson?.current?.windKph,
            feelslikeC: weatherJson?.current?.feelslikeC,
            totalprecipMm: weatherJson?.current?.precipMm,
            pressureMB: weatherJson?.current?.pressureMB,
            visKM: weatherJson?.current?.visKM,
            uv: weatherJson?.current?.uv,
            text: weatherJson?.current?.condition?.text,
            conditionCode: weatherJson?.current?.condition?.code,
            
            forecastday: forecastHourly.self,
            forecastWeekly: forecastWeekly.self
        )
        if fromStatic == true {
            addWeatherLocaleWithoutCoordinates(city)
        } else {
            addWeatherLocaleWithCoordinates(city)
        }
        let weather = WeatherLocale(city: citiesWithInfo)
        return weather
    }
    
    func addWeatherLocaleWithoutCoordinates(_ city: City) {
        citiesWithInfo.append(city)
    }
    
    func addWeatherLocaleWithCoordinates(_ city: City) {
        citiesWithInfo.insert(city, at: 0)
    }
    
}


