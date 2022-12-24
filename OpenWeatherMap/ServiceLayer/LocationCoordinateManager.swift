//
//  LocationManger.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 23.12.2022.
//

import Foundation
import MapKit
import CoreLocation

protocol LocationCoordinateManagerProtocol {
    func getCoordinates(completion: @escaping (String?) -> ())
    var coordinates: String? { get set }
}

class LocationCoordinateManager: NSObject, LocationCoordinateManagerProtocol, CLLocationManagerDelegate {
    
    var latitude: String?
    var longitude: String?
    var coordinates: String?
    let locationManager = CLLocationManager()
    
    func getCoordinates(completion: @escaping (String?) -> ()) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
        completion(coordinates ?? "")
        getUserAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = "\(locValue.latitude)"
        longitude = "\(locValue.longitude)"
        coordinates = "https://api.weatherapi.com/v1/forecast.json?key=7503255f426a420db0a122740222212&q=" + (latitude ?? "") + "," + (longitude ?? "") + "&days=7&aqi=no&alerts=no"
        
    }
    
    func getUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}


