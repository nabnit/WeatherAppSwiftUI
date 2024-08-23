//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Nabnit Patnaik on 8/20/24.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    var mockAPIService: MockApiService!
    var sut: WeatherViewModel?
    var mockVC: ViewController!

    // CAN BE DONE - Unit test cases can be added for all the scenarios in swift ui
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIService = MockApiService()
        sut = WeatherViewModel(apiservice: mockAPIService)
        mockVC = ViewController()
        mockVC.weatherViewModel = sut ?? WeatherViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        mockAPIService = nil
        mockVC = nil
        super.tearDown()
    }
    // test preload
    func testPreload() {
        LocalStorage.shared.saveCity("dallas")
        mockVC.viewDidLoad()
        mockVC.fetchData(LocalStorage.shared.fetchCity())
        XCTAssert(mockAPIService.getWeatherDetailsCalled)
    }
    
    func testLocalCache() {
        LocalStorage.shared.saveCity("dallas")
        XCTAssert(LocalStorage.shared.fetchCity() == "dallas")
    }
    
    // CAN BE DONE - We can use XCTestExpectation to test the async api calls. Create an expection. Wait some time for it(wait(for: [expectation], timeout: 10.0)) to complete and then fulfill expectation when we get the api response(expectation.fulfill()).
    
    func testGetImageDetails_success() {
        sut?.fetchImage(name: "01d")
        XCTAssert(mockAPIService.getImageDetailsCalled)
        mockAPIService.fetchImageSuccess()
//        XCTAssert(mockVC.fetchImageSuccessCalled)
    }
    
    func testSaveImageInCache() {
        let url = URL(string: "https://abc.com")
        LocalStorage.shared.saveImageInCache(img: UIImage(systemName: "info.circle")!, key: url! as NSURL)
        
        XCTAssert(LocalStorage.shared.fetchImageFromCache(key: url! as NSURL) != nil)
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
class MockApiService: APIServiceProtocol {
    var getWeatherDetailsCalled = false
    var getImageDetailsCalled = false
    var isSuccess = true
    var weatherCompletionhandler: ((WeatherModel?, WeatherError?) -> Void)?
    var imageCompletionhandler: ((Data?, Error?) -> Void)?
    var error: WeatherError = .invalidCity
    
    func getWeatherDetails(city: String, completion: @escaping ((WeatherModel?, WeatherError?) -> Void)) {
        getWeatherDetailsCalled = true
        weatherCompletionhandler = completion
    }
    
    func getImageDetails(url: URL, completion: @escaping ((Data?, Error?) -> Void)) {
        getImageDetailsCalled = true
        imageCompletionhandler = completion
    }
    
    func fetchSuccess() {
        let mockResponse = "{\"coord\":{\"lon\":151.2073,\"lat\":-33.8679},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"clear sky\",\"icon\":\"01d\"}],\"main\":{\"temp\":306.24,\"feels_like\":312.18,\"temp_min\":304.83,\"temp_max\":307.62,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":994},\"sys\":{\"type\":2,\"sunrise\":1724271980,\"sunset\":1724311814},\"timezone\":36000,\"id\":2147714,\"name\":\"Sydney\",\"cod\":200}"
        do {
            let result = try JSONDecoder().decode(WeatherModel.self, from: mockResponse.data(using: .utf8)!)
            weatherCompletionhandler?( result, nil )
        }
        catch {
            print(error)
        }
    }
    
    func fetchFailure() {
        weatherCompletionhandler?( nil, error )
    }
    
    func fetchImageSuccess() {
        guard let img = UIImage(systemName: "info.circle"), let imgData = img.pngData() else { return }
        imageCompletionhandler?(imgData, nil )
    }
    
    func fetchImageDownloadFailure() {
        imageCompletionhandler?( nil, error )
    }
}
