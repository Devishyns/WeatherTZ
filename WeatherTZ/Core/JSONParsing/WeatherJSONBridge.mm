//
//  WeatherJSONBridge.mm
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

#import "WeatherJSONBridge.h"

#include <tao/json.hpp>
#include <string>

// Keys
NSString *const kWeatherKeyTemp        = @"temp";
NSString *const kWeatherKeyFeelsLike   = @"feels_like";
NSString *const kWeatherKeyHumidity    = @"humidity";
NSString *const kWeatherKeyPressure    = @"pressure";
NSString *const kWeatherKeyWindSpeed   = @"wind_speed";
NSString *const kWeatherKeyVisibility  = @"visibility";
NSString *const kWeatherKeyClouds      = @"clouds";
NSString *const kWeatherKeyDescription = @"description";
NSString *const kWeatherKeyIcon        = @"icon";
NSString *const kWeatherKeyDt          = @"dt";
NSString *const kWeatherKeyTempMin     = @"temp_min";
NSString *const kWeatherKeyTempMax     = @"temp_max";

namespace {

// Извлекает число (double) по ключу, 0.0 если нет
double safeDouble(const tao::json::value &obj, const std::string &key) {
    try {
        const auto &val = obj.at(key);
        if (val.is_double()) return val.get_double();
        if (val.is_signed()) return static_cast<double>(val.get_signed());
        if (val.is_unsigned()) return static_cast<double>(val.get_unsigned());
    } catch (...) {}
    return 0.0;
}

// Извлекает целое число
long long safeInt(const tao::json::value &obj, const std::string &key) {
    try {
        const auto &val = obj.at(key);
        if (val.is_signed()) return val.get_signed();
        if (val.is_unsigned()) return static_cast<long long>(val.get_unsigned());
        if (val.is_double()) return static_cast<long long>(val.get_double());
    } catch (...) {}
    return 0;
}

// Извлекает строку
std::string safeString(const tao::json::value &obj, const std::string &key) {
    try {
        const auto &val = obj.at(key);
        if (val.is_string()) return val.get_string();
    } catch (...) {}
    return "";
}

// Достаёт description и icon из массива "weather"
std::pair<std::string, std::string> extractWeatherInfo(const tao::json::value &obj) {
    try {
        const auto &arr = obj.at("weather").get_array();
        if (!arr.empty()) {
            return {
                safeString(arr[0], "description"),
                safeString(arr[0], "icon")
            };
        }
    } catch (...) {}
    return {"", ""};
}

} // anonymous namespace

@implementation WeatherJSONBridge

+ (nullable NSDictionary<NSString *, id> *)parseCurrentFromJSON:(NSString *)jsonString
                                                          error:(NSError **)error {
    if (!jsonString || jsonString.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Empty JSON"}];
        }
        return nil;
    }

    try {
        std::string str = [jsonString UTF8String];
        const auto root = tao::json::from_string(str);

        // Проверяем наличие "current"
        if (!root.find("current")) {
            if (error) {
                *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:2
                                         userInfo:@{NSLocalizedDescriptionKey: @"Missing 'current' object"}];
            }
            return nil;
        }

        const auto &current = root.at("current");
        auto [desc, icon] = extractWeatherInfo(current);

        return @{
            kWeatherKeyTemp:        @(safeDouble(current, "temp")),
            kWeatherKeyFeelsLike:   @(safeDouble(current, "feels_like")),
            kWeatherKeyHumidity:    @(safeInt(current, "humidity")),
            kWeatherKeyPressure:    @(safeInt(current, "pressure")),
            kWeatherKeyWindSpeed:   @(safeDouble(current, "wind_speed")),
            kWeatherKeyVisibility:  @(safeInt(current, "visibility")),
            kWeatherKeyClouds:      @(safeInt(current, "clouds")),
            kWeatherKeyDescription: [NSString stringWithUTF8String:desc.c_str()],
            kWeatherKeyIcon:        [NSString stringWithUTF8String:icon.c_str()],
            kWeatherKeyDt:          @(safeInt(current, "dt")),
        };
    } catch (const tao::pegtl::parse_error &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:3
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"Parse error: %s", e.what()]}];
        }
        return nil;
    } catch (const std::exception &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:4
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"C++ error: %s", e.what()]}];
        }
        return nil;
    }
}

+ (nullable NSArray<NSDictionary<NSString *, id> *> *)parseDailyFromJSON:(NSString *)jsonString
                                                                   error:(NSError **)error {
    if (!jsonString || jsonString.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:1
                                     userInfo:@{NSLocalizedDescriptionKey: @"Empty JSON"}];
        }
        return nil;
    }

    try {
        std::string str = [jsonString UTF8String];
        const auto root = tao::json::from_string(str);

        if (!root.find("daily") || !root.at("daily").is_array()) {
            if (error) {
                *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:2
                                         userInfo:@{NSLocalizedDescriptionKey: @"Missing 'daily' array"}];
            }
            return nil;
        }

        const auto &dailyArr = root.at("daily").get_array();
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:dailyArr.size()];

        for (const auto &day : dailyArr) {
            auto [desc, icon] = extractWeatherInfo(day);

            // temp — объект с min/max
            double tempMin = 0, tempMax = 0;
            try {
                const auto &temp = day.at("temp");
                tempMin = safeDouble(temp, "min");
                tempMax = safeDouble(temp, "max");
            } catch (...) {}

            // visibility может отсутствовать в daily
            long long visibility = safeInt(day, "visibility");

            [result addObject:@{
                kWeatherKeyDt:          @(safeInt(day, "dt")),
                kWeatherKeyTempMin:     @(tempMin),
                kWeatherKeyTempMax:     @(tempMax),
                kWeatherKeyPressure:    @(safeInt(day, "pressure")),
                kWeatherKeyHumidity:    @(safeInt(day, "humidity")),
                kWeatherKeyVisibility:  @(visibility),
                kWeatherKeyClouds:      @(safeInt(day, "clouds")),
                kWeatherKeyDescription: [NSString stringWithUTF8String:desc.c_str()],
                kWeatherKeyIcon:        [NSString stringWithUTF8String:icon.c_str()],
            }];
        }

        return [result copy];
    } catch (const tao::pegtl::parse_error &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:3
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"Parse error: %s", e.what()]}];
        }
        return nil;
    } catch (const std::exception &e) {
        if (error) {
            *error = [NSError errorWithDomain:@"WeatherJSONBridge" code:4
                                     userInfo:@{NSLocalizedDescriptionKey:
                [NSString stringWithFormat:@"C++ error: %s", e.what()]}];
        }
        return nil;
    }
}

@end
