//
//  WeatherAppTestHelpers.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation
@testable import WeatherTZ

enum WeatherAppTestHelpers {

    static let moscow = City(id: "moscow", name: "Moscow", country: "Russia", lat: 55.7, lon: 37.6)

    static func makeCurrent(
        temperature: Double = 15,
        feelsLike: Double = 13,
        humidity: Int = 60,
        pressure: Int = 1013,
        windSpeed: Double = 5.0,
        visibility: Int = 10000,
        clouds: Int = 40,
        description: String = "clear sky",
        icon: String = "01d"
    ) -> CurrentWeather {
        CurrentWeather(
            temperature: temperature,
            feelsLike: feelsLike,
            humidity: humidity,
            pressure: pressure,
            windSpeed: windSpeed,
            visibility: visibility,
            clouds: clouds,
            description: description,
            icon: icon,
            updatedAt: Date()
        )
    }

    static func makeDaily(
        id: String = "0",
        tempMin: Double = 10,
        tempMax: Double = 20,
        pressure: Int = 1015,
        humidity: Int = 55,
        visibility: Int = 10000,
        clouds: Int = 30
    ) -> DailyForecast {
        DailyForecast(
            id: id,
            date: Date(),
            tempMin: tempMin,
            tempMax: tempMax,
            pressure: pressure,
            humidity: humidity,
            visibility: visibility,
            clouds: clouds,
            description: "sunny",
            icon: "01d"
        )
    }

    static func makeCityWeather(
        city: City = moscow,
        temperature: Double = 15,
        dailyCount: Int = 7
    ) -> CityWeather {
        let current = makeCurrent(temperature: temperature)
        let daily = (0..<dailyCount).map { i in
            makeDaily(id: "\(i)", tempMin: temperature - 3, tempMax: temperature + 3)
        }
        return CityWeather(city: city, current: current, daily: daily)
    }
}
