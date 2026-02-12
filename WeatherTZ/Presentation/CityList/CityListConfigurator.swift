//
//  CityListConfigurator.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI

enum CityListConfigurator {
    @MainActor
    static func configure(container: DependencyContainer = .shared) -> CityListView {
        let viewModel = CityListViewModel(repository: container.weatherRepository)
        return CityListView(viewModel: viewModel)
    }
}

