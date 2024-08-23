//
//  APIService.swift
//  Weather
//
//  Created by Nabnit Patnaik on 8/21/24.
//

import Foundation
import UIKit

enum WeatherError: Error {
    case invalidCity
    case networkError
    case others
}

protocol APIServiceProtocol {
    func getWeatherDetails(city: String, completion: @escaping ((WeatherModel?, WeatherError?) -> Void))
    func getImageDetails(url: URL, completion: @escaping ((Data?, Error?) -> Void))
}

class APIService: APIServiceProtocol {
    /**
     To get weather details
     Params:
        city - city name for which the weather details is requested
     **/
    func getWeatherDetails(city: String, completion: @escaping ((WeatherModel?, WeatherError?) -> Void)) {
        let url = String(format: WeatherConstants.baseWeatherUrl, city, WeatherConstants.apiKey)
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        print(url)
        makeAPIRequest(urlRequest) { data, error in
            guard let data = data as? Data, error == nil else {
                completion(nil, error)
                
                return
            }
            do {
                let result = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(result, nil)
            }
            catch {
                print(error)
            }
        }
    }
    
    /**
     To get imagedata
     Params:
        url - url for the image to be downloaded
     **/
    func getImageDetails(url: URL, completion: @escaping ((Data?, Error?) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, error)
        }.resume()
    }
    
    // Making a request based on the url passed
    private func makeAPIRequest(_ url: URLRequest, completion: @escaping ((Any?, WeatherError?) -> Void)) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data, error == nil else {
                if let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 404 {
                    completion(response, .invalidCity)
                } else {
                    completion(nil, .others)
                }
                return
            }
            completion(data, nil)
            
        }
        session.resume()
    }
}
