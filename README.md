# WeatherTZ

Тестовое задание - погода для столиц мира (OpenWeatherMap One Call API 3.0).

## Запуск

1. Клонировать репозиторий или скачать в виде архива.
2. Скачать C++ зависимости:
```bash
cd LunaIdTZ
mkdir Vendor
cd Vendor
git clone https://github.com/taocpp/json.git taocpp-json
git clone https://github.com/taocpp/PEGTL.git taocpp-pegtl
```

3. В Xcode → Build Settings → **Header Search Paths** добавить:
```
$(SRCROOT)/Vendor/taocpp-json/include
$(SRCROOT)/Vendor/taocpp-pegtl/include

Выбрать recursive
```

4. В `Helpers/Constants.swift` вставить свой API ключ:
```swift
static let apiKey = "Вставить свой API ключ"
```

Ключ можно получить на [openweathermap.org]([https://openweathermap.org/api](https://home.openweathermap.org/subscriptions)) - подписка Base plan

## Стек

- SwiftUI, iOS 16+
- async/await, TaskGroup
- MVVM + Configurator
- taocpp/json (C++ парсинг через Obj-C++ мост)
- XCTest
