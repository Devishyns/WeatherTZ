//
//  Weather.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

/// Текущая погода для города
struct CurrentWeather: Hashable, Sendable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let visibility: Int
    let clouds: Int
    let description: String
    let icon: String
    let updatedAt: Date

    var isCold: Bool { temperature < Constants.Weather.coldThreshold }
}

/// Дневной прогноз
struct DailyForecast: Identifiable, Hashable, Sendable {
    let id: String                // дата как строка
    let date: Date
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let visibility: Int
    let clouds: Int
    let description: String
    let icon: String

    var isCold: Bool { tempMax < Constants.Weather.coldThreshold }
}

/// Полная погода для города: текущая + прогноз
struct CityWeather: Identifiable, Hashable, Sendable {
    let city: City
    let current: CurrentWeather
    let daily: [DailyForecast]

    var id: String { city.id }
}
