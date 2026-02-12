//
//  WeatherRepository.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

final class WeatherRepository: IWeatherRepository {

    private let networkService: INetworkService
    private let jsonParser: IWeatherJSONParser
    private let apiKey: String

    init(
        networkService: INetworkService,
        jsonParser: IWeatherJSONParser,
        apiKey: String = Constants.API.apiKey
    ) {
        self.networkService = networkService
        self.jsonParser = jsonParser
        self.apiKey = apiKey
    }

    func fetchWeather(for city: City) async throws -> CityWeather {
        let url = try buildURL(for: city)
        let data = try await networkService.fetchData(from: url)
        return try jsonParser.parseWeather(from: data, for: city)
    }

    /// Параллельная загрузка для всех столиц через TaskGroup
    func fetchAllWeather() async -> [Result<CityWeather, Error>] {
        await withTaskGroup(of: (String, Result<CityWeather, Error>).self) { group in
            for city in City.capitals {
                group.addTask {
                    do {
                        let weather = try await self.fetchWeather(for: city)
                        return (city.id, .success(weather))
                    } catch {
                        return (city.id, .failure(error))
                    }
                }
            }

            var results: [(String, Result<CityWeather, Error>)] = []
            for await result in group {
                results.append(result)
            }

            // Сохраняем порядок столиц
            let ordered = City.capitals.compactMap { city in
                results.first { $0.0 == city.id }?.1
            }
            return ordered
        }
    }

    // MARK: - Private

    private func buildURL(for city: City) throws -> URL {
        guard var components = URLComponents(string: Constants.API.baseURL + "/onecall") else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(city.lat)"),
            URLQueryItem(name: "lon", value: "\(city.lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "exclude", value: "minutely,hourly,alerts"),
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}


