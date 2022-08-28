import 'package:flutter/material.dart';
import 'package:weather/presentation/resources/styles_manager.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'manager_values.dart';

ThemeData getAppTheme() {
  return ThemeData(
    //main color
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    disabledColor: ColorManager.grey,
    // colorScheme: ColorScheme.light(
    //     onPrimary: ColorManager.primary,
    //     background: ColorManager.primary,
    //     onBackground: ColorManager.primary,
    //     primary: ColorManager.primary),
    splashColor: ColorManager.lightPrimary,
    //this color named ripple effect show this color when click in bottom
    //Card theme
    cardTheme: CardTheme(
        color: ColorManager.grey,
        shadowColor: ColorManager.grey,
        elevation: AppSize.s4),

    //app bar Theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.primary,
      elevation: AppSize.s4,
      shadowColor: ColorManager.lightPrimary,
      titleTextStyle: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s16,
      ),
    ),

    //bottom theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: ColorManager.grey,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.lightPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
          color: ColorManager.white,
          fontSize: FontSize.s18,
        ),
        primary: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSize.s12,
          ),
        ),
      ),
    ),

    //text theme
    textTheme: TextTheme(
        headline1: getSemiBoldStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s16),
        bodyText1: getRegularStyle(
            color: ColorManager.darkGrey, fontSize: FontSize.s14),
        subtitle1:
            getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s16),
        caption: getRegularStyle(
          color: ColorManager.grey,
        )),

    //input decoration theme

    inputDecorationTheme: InputDecorationTheme(
      //content padding

      contentPadding: const EdgeInsets.symmetric(
          vertical: AppSize.s8, horizontal: AppSize.s12),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorManager.darkGrey),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),

      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorManager.darkGrey),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorManager.darkGrey),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.darkGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: ColorManager.darkGrey),
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      // labelText: hintText,
      errorStyle: getRegularStyle(color: Colors.red),
      hintStyle: getRegularStyle(color: Colors.black45, fontSize: FontSize.s18),
      labelStyle: getRegularStyle(color: Colors.black45),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    ),
  );
}
