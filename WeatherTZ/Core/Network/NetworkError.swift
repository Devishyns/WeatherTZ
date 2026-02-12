//
//  NetworkError.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case httpError(statusCode: Int)
    case decodingFailed(String)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
            case .invalidURL: "Invalid URL"
            case .noData: "No data received"
            case .httpError(let code): "HTTP error: \(code)"
            case .decodingFailed(let msg): "Decoding failed: \(msg)"
            case .unknown(let error): error.localizedDescription
        }
    }
}

