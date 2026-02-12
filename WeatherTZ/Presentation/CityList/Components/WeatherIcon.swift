//
//  WeatherIcon.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Foundation

enum WeatherIcon {
    static func sfSymbol(for code: String) -> String {
        switch code {
            case "01d": return "sun.max.fill"
            case "01n": return "moon.fill"
            case "02d": return "cloud.sun.fill"
            case "02n": return "cloud.moon.fill"
            case "03d", "03n": return "cloud.fill"
            case "04d", "04n": return "smoke.fill"
            case "09d", "09n": return "cloud.drizzle.fill"
            case "10d": return "cloud.sun.rain.fill"
            case "10n": return "cloud.moon.rain.fill"
            case "11d", "11n": return "cloud.bolt.fill"
            case "13d", "13n": return "snowflake"
            case "50d", "50n": return "cloud.fog.fill"
            default: return "cloud.fill"
        }
    }
}

