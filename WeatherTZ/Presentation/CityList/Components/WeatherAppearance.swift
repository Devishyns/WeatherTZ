//
//  WeatherAppearance.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI

/// Cтилизация по коду иконки OpenWeather
enum WeatherAppearance {
    case sunny
    case cloudy
    case rainy
    case snowy
    case foggy
    
    init(icon: String) {
        if icon.contains("01") || icon.contains("02") { self = .sunny }
        else if icon.contains("09") || icon.contains("10") || icon.contains("11") { self = .rainy }
        else if icon.contains("13") { self = .snowy }
        else if icon.contains("50") { self = .foggy }
        else { self = .cloudy }
    }
    
    var iconColor: Color {
        switch self {
            case .sunny: .orange
            case .cloudy: .gray
            case .rainy: .blue
            case .snowy: .cyan
            case .foggy: .gray.opacity(0.7)
        }
    }
    
    var headerGradient: [Color] {
        switch self {
            case .sunny:
                [Color(red: 0.98, green: 0.96, blue: 0.90), Color(red: 0.95, green: 0.94, blue: 0.92)]
            case .rainy:
                [Color(red: 0.90, green: 0.92, blue: 0.96), Color(red: 0.95, green: 0.94, blue: 0.92)]
            case .snowy:
                [Color(red: 0.93, green: 0.96, blue: 0.98), Color(red: 0.95, green: 0.94, blue: 0.92)]
            case .cloudy, .foggy:
                [Color(red: 0.96, green: 0.95, blue: 0.93), Color(red: 0.95, green: 0.94, blue: 0.92)]
        }
    }
}
