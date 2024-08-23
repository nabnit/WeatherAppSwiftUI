//
//  ViewController.swift
//  Weather
//
//  Created by Nabnit Patnaik on 8/20/24.
//

import UIKit
import CoreLocation
import SwiftUI
class ViewController: UIViewController {
    var weatherViewModel = WeatherViewModel()
    var locationManager: CLLocationManager?
    var activityIndicator = UIActivityIndicatorView()
 
    var swiftUIView: WeatherSwiftUIView? = nil

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        setupLoadingIndicator()
        setupSwiftUIView()

        // Adding this gesture to dismiss keyboard on tap of the screen
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Setup methods

    func setupSwiftUIView() {
        swiftUIView = WeatherSwiftUIView(viewModel: weatherViewModel)
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        hostingController.didMove(toParent: self)
    }
    
    // Show/Hide loading indicator
    func setupLoadingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
    }
    
    // MARK: Location permission setup
    func setupLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        // Check for the location permission status
        switch locationManager?.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default:
            // if rejected, show an alert to enable location
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(msg: "Location needs to be enabled to view weather details")
            }
        }
    }

    // MARK: API service calls to fetch data and image
    func fetchData(_ city: String) {
        
        let cityName = validateCityName(city: city)
        guard !cityName.isEmpty else {
            activityIndicator.stopAnimating()
            return
        }
        weatherViewModel.fetchWeatherData(city: cityName)
    }
    
    func fetchImage(imgName: String) {
        weatherViewModel.fetchImage(name: imgName)
    }
    
}

extension ViewController {
    func showAlert(msg: String) {
        let alert = UIAlertController(title: WeatherConstants.alert_title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(error: WeatherError?) {
        guard let error = error else {
            return
        }
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else { return }
            switch error {
            case .invalidCity:
                strongSelf.showAlert(msg: WeatherConstants.message_invalidCity)
            case .networkError:
                strongSelf.showAlert(msg: WeatherConstants.message_networkError)
            case .others:
                strongSelf.showAlert(msg: WeatherConstants.message_otherError)
            }
        }
    }
    
    func validateCityName(city: String?) -> String {
        guard let city = city else {
            return ""
        }
        // Checks for leading and trailing whitespaces
        let cityName = city.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        do {
            // only allow one space after comma to accept - city, state
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9, ].*", options: [])
            if regex.firstMatch(in: cityName, options: [], range: NSMakeRange(0, cityName.count)) != nil {
                self.showAlert(msg: WeatherConstants.message_invalidCity)
            }
        }
        catch {
            self.showAlert(msg: WeatherConstants.message_invalidCity)
        }
        
        return cityName.replacingOccurrences(of: " ", with: "")
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
// MARK: Search bar delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        // CAN BE DONE: Can be used for predictive search when we have a list of items that we can fed to the search bar and start typing characters to intiate the search from the list
    }
}

// MARK: Location manager delegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            fetchData(LocalStorage.shared.fetchCity())
        }
    }
}
