//
//  CityWeatherCard.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI

struct CityWeatherCard: View {
    let weather: CityWeather
    let isRefreshing: Bool
    let onRefresh: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(weather.city.displayName)
                    .font(.system(size: 18, weight: .semibold))

                Text(CityDetailViewModel.russianDescription(weather.current.description))
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 8) {
                Text("\(Int(weather.current.temperature))°")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(weather.current.isCold ? .blue : .primary)

                Image(systemName: WeatherIcon.sfSymbol(for: weather.current.icon))
                    .font(.system(size: 20))
                    .foregroundStyle(WeatherAppearance(icon: weather.current.icon).iconColor)
                    .frame(width: 28)
            }

            Button {
                onRefresh()
            } label: {
                if isRefreshing {
                    ProgressView()
                        .controlSize(.small)
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .frame(width: 24, height: 24)
                }
            }
            .buttonStyle(.plain)
            .disabled(isRefreshing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(cardBackground)
    }

    // MARK: - Appearance

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(weather.current.isCold ? coldFill : warmFill)
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    private var warmFill: Color {
        Color(.systemBackground)
    }

    private var coldFill: Color {
        Color(red: 0.92, green: 0.95, blue: 1.0)
    }
}
