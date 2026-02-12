//
//  CityDetailConfigurator.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI

enum CityDetailConfigurator {
    @MainActor
    static func configure(cityWeather: CityWeather) -> CityDetailView {
        let viewModel = CityDetailViewModel(cityWeather: cityWeather)
        return CityDetailView(viewModel: viewModel)
    }
}

