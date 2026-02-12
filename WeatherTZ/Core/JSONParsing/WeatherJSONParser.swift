//
//  WeatherJSONParser.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

final class WeatherJSONParser: IWeatherJSONParser {

    func parseWeather(from data: Data, for city: City) throws -> CityWeather {
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw NetworkError.decodingFailed("Не удалось конвертировать Data в UTF-8")
        }

        let current = try parseCurrent(jsonString)
        let daily = try parseDaily(jsonString)

        return CityWeather(city: city, current: current, daily: daily)
    }

    // MARK: - Private

    private func parseCurrent(_ json: String) throws -> CurrentWeather {
        let dict: [String: Any]
        do {
            dict = try WeatherJSONBridge.parseCurrent(fromJSON: json) as? [String: Any] ?? [:]
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }

        let dt = dict[kWeatherKeyDt] as? TimeInterval ?? 0

        return CurrentWeather(
            temperature: dict[kWeatherKeyTemp] as? Double ?? 0,
            feelsLike: dict[kWeatherKeyFeelsLike] as? Double ?? 0,
            humidity: dict[kWeatherKeyHumidity] as? Int ?? 0,
            pressure: dict[kWeatherKeyPressure] as? Int ?? 0,
            windSpeed: dict[kWeatherKeyWindSpeed] as? Double ?? 0,
            visibility: dict[kWeatherKeyVisibility] as? Int ?? 0,
            clouds: dict[kWeatherKeyClouds] as? Int ?? 0,
            description: dict[kWeatherKeyDescription] as? String ?? "",
            icon: dict[kWeatherKeyIcon] as? String ?? "",
            updatedAt: Date(timeIntervalSince1970: dt)
        )
    }
    
    private func parseDaily(_ json: String) throws -> [DailyForecast] {
        let rawDays: [[String: Any]]
        do {
            let arr = try WeatherJSONBridge.parseDaily(fromJSON: json)
            rawDays = arr.compactMap { $0 as? [String: Any] }
        } catch {
            throw NetworkError.decodingFailed(error.localizedDescription)
        }

        return rawDays.enumerated().compactMap { index, dict in
            let dt = dict[kWeatherKeyDt] as? TimeInterval ?? 0
            let date = Date(timeIntervalSince1970: dt)

            return DailyForecast(
                id: "\(index)_\(Int(dt))",
                date: date,
                tempMin: dict[kWeatherKeyTempMin] as? Double ?? 0,
                tempMax: dict[kWeatherKeyTempMax] as? Double ?? 0,
                pressure: dict[kWeatherKeyPressure] as? Int ?? 0,
                humidity: dict[kWeatherKeyHumidity] as? Int ?? 0,
                visibility: dict[kWeatherKeyVisibility] as? Int ?? 0,
                clouds: dict[kWeatherKeyClouds] as? Int ?? 0,
                description: dict[kWeatherKeyDescription] as? String ?? "",
                icon: dict[kWeatherKeyIcon] as? String ?? ""
            )
        }
    }
}
