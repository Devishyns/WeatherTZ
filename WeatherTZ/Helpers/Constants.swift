//
//  Constants.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

enum Constants {

    enum API {
        static let baseURL = "https://api.openweathermap.org/data/3.0"
        static let apiKey = "f790d7d2059c5008eec79943ec645286"
    }

    enum Weather {
        /// Порог холодной температуры для цветового кодирования
        static let coldThreshold: Double = 10.0
    }
}
