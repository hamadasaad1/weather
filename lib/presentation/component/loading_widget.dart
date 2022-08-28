import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/font_manager.dart';
import 'package:weather/presentation/resources/strings_manager.dart';
import 'package:weather/presentation/resources/styles_manager.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/weather.json', width: 200, height: 200),
          if (message != null)
            Text(
              message?? AppStrings.noRouteFound,
              style: getSemiBoldStyle(color: ColorManager.white,fontSize: FontSize.s22),
            )
        ],
      ),
    );
  }
}
