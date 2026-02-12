//
//  WeatherTZTests.swift
//  WeatherTZTests
//
//  Created by yunus on 12.02.2026.
//

import XCTest
@testable import WeatherTZ

@MainActor
final class CityListViewModelTests: XCTestCase {

    private var sut: CityListViewModel!
    private var mockRepository: MockWeatherRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        sut = CityListViewModel(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func test_loadAll_success_setsWeatherData() async {
        mockRepository.mockWeather = [
            WeatherAppTestHelpers.makeCityWeather(city: WeatherAppTestHelpers.moscow),
        ]

        await sut.loadAll()

        XCTAssertEqual(sut.weatherData.count, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_loadAll_failure_setsError() async {
        mockRepository.mockError = NetworkError.httpError(statusCode: 500)

        await sut.loadAll()

        XCTAssertTrue(sut.weatherData.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
    }

    func test_refreshCity_updatesSpecificCity() async {
        let londonWeather = WeatherAppTestHelpers.makeCityWeather(city: WeatherAppTestHelpers.moscow, temperature: 15)
        mockRepository.mockWeather = [londonWeather]
        await sut.loadAll()

        let updated = WeatherAppTestHelpers.makeCityWeather(city: WeatherAppTestHelpers.moscow, temperature: 20)
        mockRepository.mockWeather = [updated]

        await sut.refreshCity("moscow")

        let temp = sut.weatherData.first?.current.temperature
        XCTAssertEqual(temp, 20)
        XCTAssertNil(sut.refreshingCityId)
    }

    func test_coldThreshold_isReflected() {
        let cold = WeatherAppTestHelpers.makeCurrent(temperature: 5)
        let warm = WeatherAppTestHelpers.makeCurrent(temperature: 15)

        XCTAssertTrue(cold.isCold)
        XCTAssertFalse(warm.isCold)
    }
}
