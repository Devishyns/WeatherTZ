//
//  INetworkService.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

/// Сетевой транспорт
protocol INetworkService: Sendable {
    func fetchData(from url: URL) async throws -> Data
}
