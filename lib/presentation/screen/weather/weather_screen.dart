import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/bloc/weather_cubit.dart';
import 'package:weather/data/remote/model/current_weather.dart';
import 'package:weather/data/remote/model/forecast_weather.dart';
import 'package:weather/data/singleton.dart';
import 'package:weather/presentation/component/component.dart';
import 'package:weather/presentation/component/gradient.dart';
import 'package:weather/presentation/component/loading_widget.dart';
import 'package:weather/presentation/component/search_city_screen.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/manager_values.dart';
import 'package:weather/presentation/resources/strings_manager.dart';
import 'package:weather/presentation/resources/styles_manager.dart';
import 'package:weather/presentation/screen/auth/login.dart';
import 'package:weather/presentation/screen/weather/widget/custom_bottom_sheet.dart';
import 'package:weather/presentation/screen/weather/widget/primary_data_row.dart';
import 'package:weather/presentation/screen/weather/widget/secondary_data_row.dart';

import '../auth/profile.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController cityController = TextEditingController();

  late WeatherCubit weatherCubit;
  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;
  String? errorMessage;

  @override
  void initState() {
    Singleton().openJsonCities();
    _getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherCubit>(
      create: (context) {
        weatherCubit = WeatherCubit();
        weatherCubit.getWeatherByCity(city: 'Cairo' , );
        weatherCubit.getForecastByCity(city: 'Cairo');

        return weatherCubit;
      },
      child: WillPopScope(
      onWillPop: () async => false,
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state is WeatherGetWeatherByCityLoadingState) {
              currentWeather = null;
              errorMessage = null;
            }
            if (state is WeatherGetWeatherByCitySuccessState) {
              currentWeather = state.currentWeather;
            }
            if (state is WeatherGetWeatherByCityErrorState) {
              errorMessage = AppStrings.noRouteFound;
            }
            if (state is WeatherGetForecastSuccessState) {
              forecastWeather = state.forecastWeather;
            }
            if (state is WeatherGetForecastLoadingState) {
              forecastWeather = null;
            }
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                  gradient: backgroundGradient,
                  image: currentWeather == null
                      ? null
                      : DecorationImage(
                          image: AssetImage(
                            "assets/images/${weatherCubit.checkWeatherClassification(currentWeather!).name}.jpg",
                          ),
                          fit: BoxFit.cover,
                        )),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: ColorManager.lightPrimary.withOpacity(.1),
                appBar: AppBar(
                  centerTitle: true,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentWeather != null) ...[
                        Text(
                          currentWeather!.name,
                          style: getBoldStyle(
                              fontSize: 30, color: ColorManager.white),
                        ),
                        InkWell(
                          onTap: (){
                            changeNavigator(context, LoginScreen());

                          },
                          child: Icon(
                            Icons.location_on,
                            size: 25,
                            color: ColorManager.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () async {
                        var result = await changeNavigator(
                            context, SearchCityScreen(),
                            isFullScreen: true);
                        if (result != null) {
                          weatherCubit.getWeatherByCity(city: result);
                          weatherCubit.getForecastByCity(city: result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12),
                        child: Icon(
                          Icons.search_rounded,
                          size: 25,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: ()  {
                       changeNavigator(
                            context, ProfileScreen(),
                            isFullScreen: true);
                    
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12),
                        child: Icon(
                          Icons.person,
                          size: 25,
                          color: ColorManager.white,
                        ),
                      ),
                    )
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: currentWeather != null
                      ? Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  PrimaryDataRow(
                                    weather: currentWeather!,
                                  ),
                                  SecondaryDataRow(weather: currentWeather!),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (forecastWeather != null)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "tap to show forecast ",
                                    style: getRegularStyle(
                                        fontSize: 20, color: ColorManager.white),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            AppSize.s20))),
                                            context: context,
                                            builder: (context) =>
                                                CustomBottomSheet(
                                                  forecasts:
                                                      forecastWeather!.forecasts,
                                                ));
                                      },
                                      icon: Icon(
                                        Icons.keyboard_arrow_up_outlined,
                                        color: ColorManager.white,
                                        size: AppSize.s40,
                                      ))
                                ],
                              ),
                          ],
                        )
                      : LoadingWidget(
                          message: errorMessage,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _getUserLocation() async {
    var position = await Singleton().getGeoLocationPosition();

    if (position != null) {
      weatherCubit.getWeatherByCity(
          lat: position.latitude.toString(),
          lon: position.longitude.toString());
      weatherCubit.getForecastByCity(
          lat: position.latitude.toString(),
          lon: position.longitude.toString());
    }
  }
}
