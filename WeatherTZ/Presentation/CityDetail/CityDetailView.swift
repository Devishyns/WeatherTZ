//
//  CityDetailView.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI

struct CityDetailView: View {
    
    @StateObject var viewModel: CityDetailViewModel
    
    private var appearance: WeatherAppearance {
        WeatherAppearance(icon: viewModel.cityWeather.current.icon)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection
                infoGrid
                weeklySection
            }
        }
        .background(Color(red: 0.95, green: 0.94, blue: 0.92))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 1) {
                    Text(viewModel.cityWeather.city.displayName)
                        .font(.system(size: 15, weight: .semibold))
                    Text(viewModel.todayDateString)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 6) {
            Image(systemName: WeatherIcon.sfSymbol(for: viewModel.cityWeather.current.icon))
                .font(.system(size: 52))
                .foregroundStyle(appearance.iconColor)
                .shadow(color: iconColor(viewModel.cityWeather.current.icon).opacity(0.3), radius: 12, y: 4)
                .padding(.top, 20)
            
            Text("\(Int(viewModel.cityWeather.current.temperature))°")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Text(viewModel.weatherDescription)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: appearance.headerGradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    // MARK: - Info Grid
    
    private var infoGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            infoTile(
                icon: "wind",
                label: "Ветер",
                value: "\(String(format: "%.1f", viewModel.cityWeather.current.windSpeed)) м/с"
            )
            infoTile(
                icon: "thermometer.medium",
                label: "Ощущается",
                value: "\(Int(viewModel.cityWeather.current.feelsLike))°"
            )
            infoTile(
                icon: "humidity.fill",
                label: "Влажность",
                value: "\(viewModel.cityWeather.current.humidity)%"
            )
            infoTile(
                icon: "gauge.medium",
                label: "Давление",
                value: "\(viewModel.cityWeather.current.pressure) гПа"
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
    }
    
    private func infoTile(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.primary.opacity(0.6))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }
    
    // MARK: - Weekly
    
    private var weeklySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Прогноз на 7 дней")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            ForEach(viewModel.weeklyForecast) { day in
                dayRow(day)
            }
        }
        .padding(.bottom, 32)
    }
    
    private func dayRow(_ day: DailyForecast) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.dayName(for: day.date))
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 36, alignment: .leading)
                
                Image(systemName: WeatherIcon.sfSymbol(for: day.icon))
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor(day.icon))
                    .frame(width: 24)
                
                Spacer()
                
                HStack(spacing: 12) {
                    detailBadge(icon: "humidity.fill", value: "\(day.humidity)%")
                    detailBadge(icon: "gauge.medium", value: "\(day.pressure)")
                    detailBadge(icon: "cloud.fill", value: "\(day.clouds)%")
                }
                
                Spacer()
                
                Text("\(Int(day.tempMin))°")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(width: 30, alignment: .trailing)
                
                tempBar(min: day.tempMin, max: day.tempMax, isCold: day.isCold)
                    .frame(width: 50, height: 4)
                
                Text("\(Int(day.tempMax))°")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(day.isCold ? .blue : .primary)
                    .frame(width: 30, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            Divider().padding(.leading, 20)
        }
        .background(Color(.systemBackground).opacity(0.01))
    }
    
    private func detailBadge(icon: String, value: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 8))
            Text(value)
                .font(.system(size: 10))
        }
        .foregroundStyle(.tertiary)
    }
    
    private func tempBar(min: Double, max: Double, isCold: Bool) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: isCold
                    ? [.blue.opacity(0.4), .cyan.opacity(0.3)]
                    : [.orange.opacity(0.4), .red.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
    
    // MARK: - Helpers
    
    private var headerGradientColors: [Color] {
        let icon = viewModel.cityWeather.current.icon
        if icon.contains("01") {
            return [Color(red: 0.98, green: 0.96, blue: 0.90), Color(red: 0.95, green: 0.94, blue: 0.92)]
        }
        if icon.contains("09") || icon.contains("10") || icon.contains("11") {
            return [Color(red: 0.90, green: 0.92, blue: 0.96), Color(red: 0.95, green: 0.94, blue: 0.92)]
        }
        if icon.contains("13") {
            return [Color(red: 0.93, green: 0.96, blue: 0.98), Color(red: 0.95, green: 0.94, blue: 0.92)]
        }
        return [Color(red: 0.96, green: 0.95, blue: 0.93), Color(red: 0.95, green: 0.94, blue: 0.92)]
    }
    
    private func iconColor(_ icon: String) -> Color {
        if icon.contains("01") || icon.contains("02") { return .orange }
        if icon.contains("09") || icon.contains("10") || icon.contains("11") { return .blue }
        if icon.contains("13") { return .cyan }
        return .gray
    }
}
