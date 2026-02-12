//
//  CityDetailViewModel.swift
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

import Combine

@MainActor
final class CityDetailViewModel: ObservableObject {

    @Published private(set) var cityWeather: CityWeather

    init(cityWeather: CityWeather) {
        self.cityWeather = cityWeather
    }

    var weeklyForecast: [DailyForecast] {
        Array(cityWeather.daily.prefix(7))
    }

    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return "Сегодня, \(formatter.string(from: Date()))"
    }

    /// Описание погоды на русском
    var weatherDescription: String {
        Self.russianDescription(cityWeather.current.description)
    }

    func dayName(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Сегодня" }

        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date).capitalized
    }

    // MARK: - Маппинг OpenWeather -> русский

    static func russianDescription(_ english: String) -> String {
        let map: [String: String] = [
            "clear sky": "Ясно",
            "few clouds": "Малооблачно",
            "scattered clouds": "Облачно",
            "broken clouds": "Облачно с прояснениями",
            "overcast clouds": "Пасмурно",
            "light rain": "Небольшой дождь",
            "moderate rain": "Дождь",
            "heavy intensity rain": "Сильный дождь",
            "very heavy rain": "Ливень",
            "extreme rain": "Экстремальный ливень",
            "freezing rain": "Ледяной дождь",
            "light intensity shower rain": "Лёгкий ливень",
            "shower rain": "Ливень",
            "heavy intensity shower rain": "Сильный ливень",
            "ragged shower rain": "Неравномерный ливень",
            "light intensity drizzle": "Лёгкая морось",
            "drizzle": "Морось",
            "heavy intensity drizzle": "Сильная морось",
            "thunderstorm": "Гроза",
            "thunderstorm with light rain": "Гроза с дождём",
            "thunderstorm with rain": "Гроза с дождём",
            "thunderstorm with heavy rain": "Гроза с ливнем",
            "light snow": "Небольшой снег",
            "snow": "Снег",
            "heavy snow": "Сильный снег",
            "sleet": "Мокрый снег",
            "light shower sleet": "Лёгкий мокрый снег",
            "shower sleet": "Мокрый снег",
            "light rain and snow": "Дождь со снегом",
            "rain and snow": "Дождь со снегом",
            "mist": "Туман",
            "smoke": "Дымка",
            "haze": "Мгла",
            "fog": "Густой туман",
            "sand": "Песчаная буря",
            "dust": "Пыль",
            "volcanic ash": "Вулканический пепел",
            "squalls": "Шквал",
            "tornado": "Торнадо",
        ]
        return map[english.lowercased()] ?? english.capitalized
    }
}
