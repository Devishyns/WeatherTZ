//
//  DependencyContainer.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

final class DependencyContainer {

    static let shared = DependencyContainer()

    let networkService: INetworkService
    let jsonParser: IWeatherJSONParser
    let weatherRepository: IWeatherRepository

    private init() {
        let networkService = NetworkService()
        let jsonParser = WeatherJSONParser()

        self.networkService = networkService
        self.jsonParser = jsonParser
        self.weatherRepository = WeatherRepository(
            networkService: networkService,
            jsonParser: jsonParser
        )
    }
}
