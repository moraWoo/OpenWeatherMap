//
//  WeatherLocale.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 18.12.2022.
//

import Foundation

struct WeatherLocale: Codable {
    let city: [City]
}

struct City: Codable {
    let city: String?                   // City (name)
    let myLocation: Double?             // My location
    let lastUpdated: Int?            // Last time updated
    let tempC: Double?                  // Current temperature
    let hTemp: Double?                  // High temperature
    let lTemp: Double?                  // Low temperature
    let sunrise: String?                // Sunrise
    let sunset: String?                 // Sunset
    let chanceOfRain: Double?           // Chance of Rain
    let humidity: Double?               // Humidity
    let windKph: Double?                // Wind
    let feelslikeC: Double?             // Fills like
    let totalprecipMm: Double?          // Precipitation (осадки)
    let pressureMB: Double?             // Pressure
    let visKM: Double?                  // Visibility
    let uv: Double?                     // UV index
    let text: String?
    let conditionCode: Int?          // Icon code

    // Day forecast
    let forecastday: [ForecastHourLocale]?
    // Weekly forecast
    let forecastWeekly: [ForecastWeeklyLocale]?
}

struct ForecastHourLocale: Codable {
    let avgtempC: Double?
    let timeEpoch: Int?
    let conditionCode: Int?
}

struct ForecastWeeklyLocale: Codable {
    let date: String?
    let maxtempC: Double?
    let mintempC: Double?
    let avghumidity: Double?
    let conditionCode: Int?
}
