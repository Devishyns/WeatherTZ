//
//  MockNetworkService.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation
@testable import WeatherTZ

final class MockNetworkService: INetworkService {
    var mockData: Data?
    var mockError: Error?
    var fetchCallCount = 0

    func fetchData(from url: URL) async throws -> Data {
        fetchCallCount += 1
        if let error = mockError { throw error }
        guard let data = mockData else { throw NetworkError.noData }
        return data
    }
}
