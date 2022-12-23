//
//  DetailedPresenter.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 13.12.2022.
//

import Foundation

protocol DetailedViewProtocol: AnyObject { // Output
    func setWeatherData(weatherData: City?)
}

protocol DetailedViewPresenterProtocol: AnyObject { // Input
    init(view: DetailedViewProtocol, networkManager: NetworkManagerProtocol, weatherData: City?)
    func setWeatherData()
    var weatherData: City? { get set }
}

class DetailedPresenter: DetailedViewPresenterProtocol {
    weak var view: DetailedViewProtocol?
    let networkManager: NetworkManagerProtocol!
    var weatherData: City?
    
    required init(view: DetailedViewProtocol, networkManager: NetworkManagerProtocol, weatherData: City?) {
        self.view = view
        self.networkManager = networkManager
        self.weatherData = weatherData
    }
    
    public func setWeatherData() {
        self.view?.setWeatherData(weatherData: weatherData)
    }

}
