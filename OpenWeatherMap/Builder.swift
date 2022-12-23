//
//  Builder.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 08.12.2022.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
    static func createDetailedModule(weatherData: City?) -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let networkManager = NetworkManager()
        let locationManager = LocationCoordinateManager()

        let presenter = MainPresenter(
            view: view,
            networkManager: networkManager,
            locationManager: locationManager
        )
        view.presenter = presenter
        return view
    }
    
    static func createDetailedModule(weatherData: City?) -> UIViewController {
        let view = DetailedViewController()
        let networkManager = NetworkManager()
        let presenter = DetailedPresenter(view: view, networkManager: networkManager, weatherData: weatherData)
        view.presenter = presenter
        return view
    }
}
