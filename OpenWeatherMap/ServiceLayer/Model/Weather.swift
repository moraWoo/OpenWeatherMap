import Foundation

// MARK: - Weather
struct Weather: Codable {
    let location: Location?
    let current: Current?
    let forecast: Forecast?
}
