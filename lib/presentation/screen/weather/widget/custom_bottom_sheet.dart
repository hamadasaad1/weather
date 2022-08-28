import 'package:flutter/material.dart';
import 'package:weather/presentation/component/generate_date_time.dart';
import 'package:weather/presentation/resources/font_manager.dart';
import 'package:weather/presentation/resources/manager_values.dart';
import 'package:weather/presentation/resources/styles_manager.dart';


class CustomBottomSheet extends StatelessWidget {
  List forecasts;
  CustomBottomSheet({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const  EdgeInsets.symmetric(vertical: AppPadding.p12,horizontal: AppPadding.p8),
      child: ListView.builder(
          itemCount:forecasts.length ,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => ListTile(
            leading: Image.network(
              "http://openweathermap.org/img/wn/${forecasts[index].weather[0].icon}@2x.png",
              errorBuilder: (context, object, stackTrace) =>
              const SizedBox(),
            ),
            title: Text(
              "${forecasts[index].main.temp.round()}\xB0",
              style: getBoldStyle(color: Colors.black,fontSize: FontSize.s16),
            ),
            subtitle: Text(
              forecasts[index].weather[0].main.toString(),
              style: getSemiBoldStyle(color: Colors.grey,fontSize: FontSize.s16),
            ),
            trailing: Text(changeDateFormat(forecasts[index].dtTxt),
                style: getRegularStyle(color: Colors.black,fontSize: FontSize.s16)),
          )),
    );
  }
}
