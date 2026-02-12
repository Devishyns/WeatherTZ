//
//  CityListViewModel.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI
import Combine

@MainActor
final class CityListViewModel: ObservableObject {
    @Published private(set) var weatherData: [CityWeather] = []
    @Published private(set) var isLoading = false
    
}
