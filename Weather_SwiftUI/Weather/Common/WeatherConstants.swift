//
//  WeatherConstants.swift
//  Weather
//
//  Created by Nabnit Patnaik on 8/21/24.
//

import Foundation

struct WeatherConstants {
    // apikey for making the api service calls
    static let apiKey = "4bc27f1b64fe1c1ae9d4e1080c024bc2"
//https://api.openweathermap.org/data/2.5/weather?q=dallas&appid=4bc27f1b64fe1c1ae9d4e1080c024bc2
    static let baseWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?q=%@&units=imperial&appid=%@"
    static let imageUrl = "https://openweathermap.org/img/wn/%@.png"
    
    static let key_city = "city"
    static let alert_title = "Error"
    static let message_emptyCity = "Please enter the city name to search"
    static let message_invalidCity = "Please enter a valid City Name"
    static let message_networkError = "There seems to be a network connectivity error. Please try again later"
    static let message_otherError = "Search failed. Please try again."

    static let spacing = 16.0
    static let fontSize = 16.0

}
