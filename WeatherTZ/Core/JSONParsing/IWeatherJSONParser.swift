//
//  IWeatherJSONParser.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

/// Парсинг JSON в модели погоды. Абстракция для подмены реализации
protocol IWeatherJSONParser: Sendable {
    func parseWeather(from data: Data, for city: City) throws -> CityWeather
}

