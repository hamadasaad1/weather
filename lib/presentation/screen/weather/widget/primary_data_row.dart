import 'package:flutter/material.dart';
import 'package:weather/data/remote/model/current_weather.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/font_manager.dart';
import 'package:weather/presentation/resources/styles_manager.dart';


class PrimaryDataRow extends StatelessWidget {
  CurrentWeather weather;

  PrimaryDataRow({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${weather.main.temp.round()}\xB0",
                style:  getSemiBoldStyle(
                  fontSize: FontSize.s100,
                  color: ColorManager.white
                ),
              ),
              Text(
                "${weather.main.tempMax.round()}\xB0 / "
                "${weather.main.tempMin.round()}\xB0",
                style: getRegularStyle(fontSize: FontSize.s20,color: ColorManager.white),
              )
            ],
          ),
        ),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.network(
            "http://openweathermap.org/img/wn/${weather.weather[0].icon}@2x.png",
            errorBuilder: (context,object, stackTrace) => const SizedBox(),
          ),
          Text(
            weather.weather[0].main,
            style:  getSemiBoldStyle(fontSize: FontSize.s30, color: ColorManager.white),
          ),
          Text(
            weather.weather[0].description,
            style: getRegularStyle(fontSize: FontSize.s22,color: ColorManager.white),
          )
        ]))
      ],
    );
  }
}
