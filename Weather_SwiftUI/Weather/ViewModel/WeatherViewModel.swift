//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Nabnit Patnaik on 8/21/24.
//

import Foundation
import UIKit

protocol WeatherDetailsProtocol: AnyObject {
    func weatherDetailsFetchSuccess(model: WeatherModelProtocol)
    func onFailure(error: WeatherError?)
    func weatherIconDownloadSuccess(image: UIImage) 
}

class WeatherViewModel: ObservableObject {
    let apiService: APIServiceProtocol
    weak var vmDelegate: WeatherDetailsProtocol?
    @Published var model = WeatherModel()
    @Published var iconImage = UIImage()
    init(apiservice: APIServiceProtocol = APIService()) {
        self.apiService = apiservice
    }
    
    /**
     // Fetch weather data
     // PARAMS:
     //     city - city name to fetch the weather details
     **/
    
    func fetchWeatherData(city: String) {
        apiService.getWeatherDetails(city: city) { [weak self] response, error in
            guard let strongSelf = self else {return}
            guard let data = response, error == nil else {
                strongSelf.vmDelegate?.onFailure(error: error)
                return
            }
            DispatchQueue.main.async {
//                strongSelf.vmDelegate?.weatherDetailsFetchSuccess(model: data)
                strongSelf.model = data
                strongSelf.fetchImage(name: data.weather?.first?.icon ?? "")
            }

            LocalStorage.shared.saveCity(city)
        }
    }
    
    /**
      Fetch weather data
      PARAMS:
         name - image name to fetch the icon image
     **/
    func fetchImage(name: String) {
        let url = String(format: WeatherConstants.imageUrl, name)
        guard let url = URL(string: url) else {
            vmDelegate?.onFailure(error: .others)
            return
        }
        
        // Check if the image is available in the local cache
        if let cachedImage = LocalStorage.shared.fetchImageFromCache(key: url as NSURL) {
            vmDelegate?.weatherIconDownloadSuccess(image: cachedImage)
            iconImage = cachedImage
            return
        }
        
        // If image is not available in local cache then download the image from the specified url
        apiService.getImageDetails(url: url) {[weak self] response, error in
            guard let strongSelf = self else {return}

            guard let data = response, let img = UIImage(data: data), error == nil else {
                strongSelf.vmDelegate?.onFailure(error: .others)
                return
            }
            // Cache the image after download to avaoid multiple image download calls
            LocalStorage.shared.saveImageInCache(img: img, key: url as NSURL)
//            strongSelf.vmDelegate?.weatherIconDownloadSuccess(image: img)
            strongSelf.iconImage = img

        }
    }
}
