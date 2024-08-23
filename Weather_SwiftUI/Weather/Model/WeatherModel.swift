//
//  WeatherModel.swift
//  Weather
//
//  Created by Nabnit Patnaik on 8/21/24.
//

import Foundation
import UIKit

protocol WeatherModelProtocol {
    func getCityName() -> String
    func getTemp() -> (current: Double?, min: Double?, max: Double?, feelsLike: Double?)
    func getIconImageName() -> String?
    func getDescription() -> String?
}
struct WeatherModel: Codable {
    var coord: Coord?
    var main: Main?
    var weather: [WeatherDetails]?
    
    var name: String = ""
    var sys: SysDetails?
    var id: Double = 0.0
    var cod: Int = 0
    var message: String?
    
    enum Coding: String, CodingKey {
        case coord
        case main
        case weather
        case name
        case sys
        case id
        case cod
        case message
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: Coding.self)
        self.coord = try data.decodeIfPresent(Coord.self, forKey: .coord)
        self.main = try data.decodeIfPresent(Main.self, forKey: .main)
        self.weather = try data.decodeIfPresent([WeatherDetails].self, forKey: .weather)
        self.name = try data.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.sys = try data.decodeIfPresent(SysDetails.self, forKey: .sys)
        self.id = try data.decodeIfPresent(Double.self, forKey: .id) ?? 0.0
        self.cod = try data.decodeIfPresent(Int.self, forKey: .cod) ?? 0
        self.message = try data.decodeIfPresent(String?.self, forKey: .message) ?? ""
    }
    
    init() {}
}

// Model protocol implementation to provide the model values
extension WeatherModel: WeatherModelProtocol {
    
    func getCityName() -> String {
        return name
    }
    func getTemp() -> (current: Double?, min: Double?, max: Double?, feelsLike: Double?) {
        return (current: main?.temp, min: main?.temp_min, max: main?.temp_max, feelsLike: main?.feels_like)
    }
    func getIconImageName() -> String? {
        return weather?.first?.icon
    }
    func getDescription() -> String? {
        return weather?.first?.description
    }
}

struct Coord: Codable {
    var lat: Double
    var lon: Double
    
    enum CodingK: String, CodingKey {
        case lat
        case lon
    }
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingK.self)
        self.lat = try data.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        self.lon = try data.decodeIfPresent(Double.self, forKey: .lon) ?? 0.0
    }
}

struct Main: Codable {

    var temp: Double
    var feels_like: Double
    var humidity: Double
    var temp_min: Double
    var temp_max: Double
    var sea_level: Double
    var grnd_level: Double
    
    enum CodingK: String, CodingKey {
        case temp
        case feels_like
        case humidity
        case temp_min
        case temp_max
        case sea_level
        case grnd_level
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingK.self)
        self.temp = try data.decodeIfPresent(Double.self, forKey: .temp) ?? 0.0
        self.feels_like = try data.decodeIfPresent(Double.self, forKey: .feels_like) ?? 0.0
        self.humidity = try data.decodeIfPresent(Double.self, forKey: .humidity) ?? 0.0
        self.temp_min = try data.decodeIfPresent(Double.self, forKey: .temp_min) ?? 0.0
        self.temp_max = try data.decodeIfPresent(Double.self, forKey: .temp_max) ?? 0.0
        self.sea_level = try data.decodeIfPresent(Double.self, forKey: .sea_level) ?? 0.0
        self.grnd_level = try data.decodeIfPresent(Double.self, forKey: .grnd_level) ?? 0.0

    }
}

struct SysDetails: Codable {
    var id: Double
    var type: Double
    var country: String
    var sunrise: Double
    var sunset: Double
    
    enum CodingK: String, CodingKey {
        case id
        case type
        case country
        case sunrise
        case sunset
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingK.self)
        self.id = try data.decodeIfPresent(Double.self, forKey: .id) ?? 0.0
        self.type = try data.decodeIfPresent(Double.self, forKey: .type) ?? 0.0
        self.country = try data.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.sunrise = try data.decodeIfPresent(Double.self, forKey: .sunrise) ?? 0.0
        self.sunset = try data.decodeIfPresent(Double.self, forKey: .sunset) ?? 0.0
    }
}

struct WeatherDetails: Codable {
    var id: Double
    var main: String
    var description: String
    var icon: String
    
    enum CodingK: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingK.self)
        self.id = try data.decodeIfPresent(Double.self, forKey: .id) ?? 0.0
        self.main = try data.decodeIfPresent(String.self, forKey: .main)  ?? ""
        self.description = try data.decodeIfPresent(String.self, forKey: .description)  ?? ""
        self.icon = try data.decodeIfPresent(String.self, forKey: .icon)  ?? ""
    }
}
