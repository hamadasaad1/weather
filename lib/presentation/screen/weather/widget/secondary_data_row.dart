import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather/data/remote/model/current_weather.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/manager_values.dart';

import 'details_card.dart';


class SecondaryDataRow extends StatelessWidget {
  CurrentWeather weather;
  SecondaryDataRow({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          DetailsCard(
            title: "humidity",
            data: "${weather.main.humidity}%",
            icon: SfRadialGauge(
              axes: [
                RadialAxis(
                  showTicks: false,
                  showLabels: false,
                  minimum: AppSize.s0,
                  maximum: AppSize.s100,
                  axisLineStyle: AxisLineStyle(
                    cornerStyle: CornerStyle.bothCurve,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: weather.main.humidity.toDouble(),
                      cornerStyle: CornerStyle.bothCurve,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          DetailsCard(
            title: "Visibility",
            data: "${weather.visibility / 1000}km",
            icon:  Icon(
              Icons.visibility_outlined,
              size: AppSize.s40,
              color: ColorManager.white.withOpacity(.4),
            ),
          ),
        ]),
        //Divider(thickness: 10,)
      ],
    );
  }
}
