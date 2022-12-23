//
//  MainPresenter.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 08.12.2022.
//

import Foundation

protocol MainViewProtocol: AnyObject { // Output
    func success()
    func failure(error: Error)
    var coordinatesOutput: String? { get set }
}

protocol MainViewPresenterProtocol: AnyObject { // Input
    init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, locationManager: LocationCoordinateManagerProtocol)
    
    func getDataFromWheatherApiWithoutCoordinates()
    func getDataFromWheatherApiWithCoordinates(url: String?)
    func getCoordinates()
    func getCities() -> [String]
    
    var weatherData: WeatherLocale? { get set }
    var weatherDataWithLocation: WeatherLocale? { get set }
    var coordinates: String? { get set }
}

class MainPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var networkManager: NetworkManagerProtocol!
    var locationCoordinateManager: LocationCoordinateManagerProtocol!
    var weatherData: WeatherLocale?
    var weatherDataWithLocation: WeatherLocale?
    var coordinates: String?
    
    required init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, locationManager: LocationCoordinateManagerProtocol) {
        self.view = view
        self.networkManager = networkManager
        self.locationCoordinateManager = locationManager
        getCoordinates()
        getDataFromWheatherApiWithoutCoordinates()
    }
    
    func getCities() -> [String] {
        let cities = networkManager.cities
        return cities
    }
    
    func getDataFromWheatherApiWithoutCoordinates() {
        networkManager.getDataFromWheatherApiWithoutCoodinates { [weak self] weather in
            guard let self = self else { return }
            self.weatherData = weather
            self.view?.success()
        }
    }
    
    func getDataFromWheatherApiWithCoordinates(url: String?) {
        networkManager.getDataFromWheatherApiWithCoordinates(url: url) { [weak self] weather in
            guard let self = self else { return }
            self.weatherData = weather
            self.view?.success()
        }
    }
    
    func getCoordinates() {
        locationCoordinateManager.getCoordinates { [weak self] coordinatesFromLocMan in
            guard let self = self else { return }
            print("1.mainPresenter: \(coordinatesFromLocMan)++")
            self.coordinates = coordinatesFromLocMan
            self.view?.success()
        }
        self.getDataFromWheatherApiWithCoordinates(url: self.coordinates)
        print("2.mainPresenter\(self.coordinates)")
    }
}
