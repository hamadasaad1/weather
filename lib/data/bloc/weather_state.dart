part of 'weather_cubit.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}
class WeatherGetWeatherByCityLoadingState extends WeatherState {}
class WeatherGetWeatherByCityErrorState extends WeatherState {}
class WeatherGetWeatherByCitySuccessState extends WeatherState {
  final CurrentWeather currentWeather;

  WeatherGetWeatherByCitySuccessState(this.currentWeather);
}

class WeatherGetForecastLoadingState extends WeatherState {}
class WeatherGetForecastErrorState extends WeatherState {}
class WeatherGetForecastSuccessState extends WeatherState {
  final ForecastWeather forecastWeather;

  WeatherGetForecastSuccessState(this.forecastWeather);
}
