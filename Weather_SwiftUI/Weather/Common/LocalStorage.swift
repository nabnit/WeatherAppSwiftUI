//
//  LocalStorage.swift
//  Weather
//
//  Created by Nabnit Patnaik on 8/21/24.
//

import Foundation
import UIKit

class LocalStorage {
    static let shared = LocalStorage()
    private let cachedImages = NSCache<NSURL, UIImage>()
    private init() {}
    
    func saveCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: WeatherConstants.key_city)
        UserDefaults.standard.synchronize()
    }
    func fetchCity() -> String {
        return UserDefaults.standard.value(forKey: WeatherConstants.key_city) as? String ?? ""
    }
    
    // To save the images in local cache
    func saveImageInCache(img: UIImage, key: NSURL) {
        cachedImages.setObject(img, forKey: key)
    }
    
    // To fetch the images from local cache
    func fetchImageFromCache(key: NSURL) -> UIImage? {
        if let cachedImage = cachedImages.object(forKey: key as NSURL){
            return cachedImage
        }
        return nil
    }
}
