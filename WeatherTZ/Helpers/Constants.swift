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
        static let apiKey = "" // Вставить свой API ключ
    }

    enum Weather {
        /// Порог холодной температуры для цветового кодирования
        static let coldThreshold: Double = 10.0
    }
}
