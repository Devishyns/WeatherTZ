//
//  CityListConfigurator.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import SwiftUI

enum CityListConfigurator {
    @MainActor
    static func configure() -> CityListView {
        let viewModel = CityListViewModel()
        return CityListView(viewModel: viewModel)
    }
}
