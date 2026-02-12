//
//  MockWeatherRepository.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation
@testable import WeatherTZ

final class MockWeatherRepository: IWeatherRepository {
    var mockWeather: [CityWeather] = []
    var mockError: Error?
    var fetchCallCount = 0

    func fetchWeather(for city: City) async throws -> CityWeather {
        fetchCallCount += 1
        if let error = mockError { throw error }
        guard let weather = mockWeather.first(where: { $0.city.id == city.id }) else {
            throw NetworkError.noData
        }
        return weather
    }

    func fetchAllWeather() async -> [Result<CityWeather, Error>] {
        if let error = mockError {
            return City.capitals.map { _ in .failure(error) }
        }
        return mockWeather.map { .success($0) }
    }
}

