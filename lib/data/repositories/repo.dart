import 'package:weather/data/remote/data_source/apis.dart';
import 'package:weather/data/remote/data_source/dio_helper.dart';
import 'package:weather/data/remote/model/current_weather.dart';
import 'package:weather/data/remote/model/forecast_weather.dart';

import 'base_repo.dart';

class WeatherRepo extends BaseRepo {
  Future<CurrentWeather?> getWeatherOfCity(
      {String? city, String? lat, String? lon}) async {
    Map<String, dynamic> query = {
      "appid": APIS().apiKey,
      "units": "metric",
    };

    if (city != null) {
      query.putIfAbsent('q', () => city);
    }

    if (lat != null) {
      query.putIfAbsent('lat', () => lat);
    }
    if (lon != null) {
      query.putIfAbsent('lon', () => lon);
    }

    var response =
        await DioHelper.getData(url: APIS().currentWeather, query: query);
    if (response.statusCode == 200) {
      return CurrentWeather.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<ForecastWeather?> getForecast(
      {String? city, String? lat, String? lon}) async {
    Map<String, dynamic> query = {
      "q": city,
      "appid": APIS().apiKey,
      "units": "metric"
    };
    if (city != null) {
      query.putIfAbsent('q', () => city);
    }

    if (lat != null) {
      query.putIfAbsent('lat', () => lat);
    }
    if (lon != null) {
      query.putIfAbsent('lon', () => lon);
    }
    var response = await DioHelper.getData(url: APIS().forecast, query: query);

    if (response.statusCode == 200) {
      return ForecastWeather.fromJson(response.data);
    } else {
      return null;
    }
  }
}
