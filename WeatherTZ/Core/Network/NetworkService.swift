//
//  NetworkService.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

/// URLSession обёртка с валидацией HTTP-статуса
final class NetworkService: INetworkService {
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "NetworkService", code: -1))
        }

        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.httpError(statusCode: http.statusCode)
        }

        return data
    }
}
