import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:weather/presentation/resources/theme_manegar.dart';
import 'package:weather/presentation/screen/home_screen.dart';

class MyApp extends StatefulWidget {
  MyApp._internal();

  factory MyApp() => MyApp._internal();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getAppTheme(),
        home: const HomeScreen(),
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init());
  }
}
