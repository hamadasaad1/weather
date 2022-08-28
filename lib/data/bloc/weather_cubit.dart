import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:weather/data/remote/model/current_weather.dart';
import 'package:weather/data/remote/model/forecast_weather.dart';
import 'package:weather/data/repositories/repo.dart';
import 'package:weather/presentation/component/generate_date_time.dart';

import '../../app/enums.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void getWeatherByCity({String? city, String? lat, String? lon}) {
    emit(WeatherGetWeatherByCityLoadingState());
    WeatherRepo()
        .getWeatherOfCity(city: city, lat: lat, lon: lon)
        .then((value) {
      if (value != null) {
        emit(WeatherGetWeatherByCitySuccessState(value));
      } else {
        emit(WeatherGetWeatherByCityErrorState());
      }
    }).catchError((onError) {
      emit(WeatherGetWeatherByCityErrorState());
    });
  }

  void getForecastByCity({String? city, String? lat, String? lon}) {
    emit(WeatherGetForecastLoadingState());
    WeatherRepo().getForecast(city: city, lat: lat, lon: lon).then((value) {
      if (value != null) {
        emit(WeatherGetForecastSuccessState(value));
      } else {
        emit(WeatherGetForecastErrorState());
      }
    }).catchError((onError) {
      emit(WeatherGetForecastErrorState());
    });
  }

  WeatherType checkWeatherClassification(CurrentWeather weather) {
    DateTime now = DateTime.now();
    DateTime sunriseTime = generateDateTime(weather.sys.sunrise);
    DateTime sunsetTime = generateDateTime(weather.sys.sunset);
    if (now.compareTo(sunriseTime) >= 0 && now.compareTo(sunsetTime) < 0) {
      if (weather.main.temp < 5) {
        return WeatherType.snow;
      } else if (weather.main.temp < 20) {
        return WeatherType.cold;
      } else {
        return WeatherType.sunny;
      }
    } else {
      return WeatherType.night;
    }
  }
}
