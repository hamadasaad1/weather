import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/bloc/auth/auth_cubit.dart';
import 'package:weather/presentation/component/component.dart';
import 'package:weather/presentation/component/loading_widget.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/strings_manager.dart';
import 'package:weather/presentation/screen/auth/login.dart';
import 'package:weather/presentation/screen/weather/weather_screen.dart';

import '../../data/local/data_source/local_cache_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit authCubit;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () => checkPreviousSession());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) {
        authCubit = AuthCubit();
        return authCubit;
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccessState) {
            changeNavigatorReplacement(context, WeatherScreen());
          }
          if (state is AuthLoginErrorState) {
            changeNavigatorReplacement(context, LoginScreen());
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorManager.primary.withOpacity(.9),
            body: const LoadingWidget(),
          );
        },
      ),
    );
  }

  void checkPreviousSession() async {
    var email = await CacheHelper.getDataFromSharedPref(key: AppStrings.email);
    var password =
        await CacheHelper.getDataFromSharedPref(key: AppStrings.password);

    if (email != null && password != null) {
      authCubit.signInWithEmailPassword(email, password);
    } else {
      changeNavigatorReplacement(context, const LoginScreen());
    }
  }
}
