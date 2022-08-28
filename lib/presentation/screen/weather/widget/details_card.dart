import 'package:flutter/material.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/font_manager.dart';
import 'package:weather/presentation/resources/styles_manager.dart';

class DetailsCard extends StatelessWidget {
  String data;
  String title;
  Widget icon;

  DetailsCard({required this.icon, required this.data, required this.title});

  @override
  build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100.withOpacity(0.3),
          //backgroundBlendMode: BlendMode.modulate
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 60, width: 60, child: icon),
            Text(
              data,
              style:  getRegularStyle(fontSize: FontSize.s22,color: ColorManager.white),
            ),
            Text(
              title,
              style:  getRegularStyle(fontSize: FontSize.s18, color:ColorManager.darkGrey),
            )
          ],
        ),
      ),
    );
  }
}
