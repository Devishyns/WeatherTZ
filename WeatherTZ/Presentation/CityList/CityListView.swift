//
//  CityListView.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI

struct CityListView: View {

    @StateObject var viewModel: CityListViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.94, blue: 0.92)
                    .ignoresSafeArea()

                Group {
                    if viewModel.isLoading && viewModel.weatherData.isEmpty {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(error)
                    } else {
                        contentView
                    }
                }
            }
            .navigationTitle("Погода")
            .refreshable {
                await viewModel.loadAll()
            }
        }
        .task {
            if viewModel.weatherData.isEmpty {
                await viewModel.loadAll()
            }
        }
    }

    // MARK: - States

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()
                .controlSize(.large)
            Text("Загрузка...")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "cloud.bolt")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Повторить") {
                Task { await viewModel.loadAll() }
            }
            .font(.footnote.weight(.medium))
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Content

    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.weatherData) { item in
                    NavigationLink(value: item) {
                        CityWeatherCard(
                            weather: item,
                            isRefreshing: viewModel.refreshingCityId == item.city.id,
                            onRefresh: {
                                Task { await viewModel.refreshCity(item.city.id) }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .navigationDestination(for: CityWeather.self) { item in
            CityDetailConfigurator.configure(cityWeather: item)
        }
    }
}



















