//
//  WeatherSwiftUIView.swift
//  Weather
//
//  Created by Nabnit Patnaik on 8/22/24.
//

import SwiftUI

struct WeatherSwiftUIView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @State private var searchtext: String = ""
    weak var navigationController: UINavigationController?
    
// CAN BE DONE - UI Validations
    var body: some View {
        VStack(spacing: 20) {
            Text("Weather Search")
                .font(.system(size: 40.0))
                .padding(.bottom)
            TextField("Enter the City name to search ...", text: $searchtext)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                Button {
                    print("Button pressed")
                    viewModel.fetchWeatherData(city: searchtext)
                    searchtext = ""
                } label: {
                    Text("Search")
                        .padding(.bottom)
                }
            Image(uiImage: viewModel.iconImage)
            
            // city name
            Text(viewModel.model.getCityName())
                .font(.title)
            
            // Current temp
            Text(String(format: "%.2f °F", (viewModel.model.getTemp().current ?? "00.00")) )
                .font(.headline)
            
            // Lowest temp
            Text(String(format: "Low: %.2f °F", (viewModel.model.getTemp().min ?? "00.00")) )
                .font(.subheadline)
            
            // Highest temp
            Text(String(format: "High: %.2f °F", (viewModel.model.getTemp().max ?? "00.00")) )
                .font(.subheadline)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)

    }
}

struct WeatherSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherSwiftUIView()
    }
}
