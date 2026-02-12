//
//  WeatherJSONBridge.h
//  WeatherTZ
//
//  Created by yunus on 12.02.2026.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Ключи для current weather
extern NSString *const kWeatherKeyTemp;
extern NSString *const kWeatherKeyFeelsLike;
extern NSString *const kWeatherKeyHumidity;
extern NSString *const kWeatherKeyPressure;
extern NSString *const kWeatherKeyWindSpeed;
extern NSString *const kWeatherKeyVisibility;
extern NSString *const kWeatherKeyClouds;
extern NSString *const kWeatherKeyDescription;
extern NSString *const kWeatherKeyIcon;
extern NSString *const kWeatherKeyDt;

// Доп. ключи для daily forecast
extern NSString *const kWeatherKeyTempMin;
extern NSString *const kWeatherKeyTempMax;

@interface WeatherJSONBridge : NSObject

/// Парсит current weather из JSON
+ (nullable NSDictionary<NSString *, id> *)parseCurrentFromJSON:(NSString *)jsonString
                                                          error:(NSError **)error;

/// Парсит массив daily forecast из JSON
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)parseDailyFromJSON:(NSString *)jsonString
                                                                   error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
