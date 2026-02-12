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
    @Published private(set) var errorMessage: String?
    @Published private(set) var refreshingCityId: String?

    private let repository: IWeatherRepository

    init(repository: IWeatherRepository) {
        self.repository = repository
    }

    // MARK: - Actions

    func loadAll() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        let results = await repository.fetchAllWeather()

        var loaded: [CityWeather] = []
        var errors: [String] = []

        for result in results {
            switch result {
                case .success(let weather):
                    loaded.append(weather)
                case .failure(let error):
                    errors.append(error.localizedDescription)
                    debugPrint("error: \(error.localizedDescription)")
            }
        }

        weatherData = loaded

        if loaded.isEmpty && !errors.isEmpty {
            errorMessage = errors.first
        }

        isLoading = false
    }
    
    /// Обновить погоду для конкретного города
    func refreshCity(_ cityId: String) async {
        guard let city = City.capitals.first(where: { $0.id == cityId }) else { return }

        refreshingCityId = cityId
        do {
            let weather = try await repository.fetchWeather(for: city)
            if let index = weatherData.firstIndex(where: { $0.city.id == cityId }) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    weatherData[index] = weather
                }
            }
        } catch {
            // Оставляю старые данные, не показываю ошибку
        }
        refreshingCityId = nil
    }
}
