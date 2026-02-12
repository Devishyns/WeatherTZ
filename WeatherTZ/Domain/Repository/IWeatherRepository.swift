//
//  IWeatherRepository.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

/// Репозиторий погоды - загрузка для города или всех столиц
protocol IWeatherRepository: Sendable {
    func fetchWeather(for city: City) async throws -> CityWeather
    func fetchAllWeather() async -> [Result<CityWeather, Error>]
}
