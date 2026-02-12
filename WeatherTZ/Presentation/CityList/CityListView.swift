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
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                Group {
                    if viewModel.isLoading && viewModel.weatherData.isEmpty {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(error)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.weatherData) { item in
                                    Text(item.city.name)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Weather")
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
    }

    // MARK: - States

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()
                .controlSize(.large)
            Text("Loading weather...")
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

            Button("Retry") {
                Task { await viewModel.loadAll() }
            }
            .font(.footnote.weight(.medium))
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
