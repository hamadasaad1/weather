import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/my_app.dart';
import 'data/bloc_observe.dart';
import 'data/local/data_source/local_cache_helper.dart';
import 'data/remote/data_source/dio_helper.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  runApp(MyApp());
  // BlocOverrides.runZoned(
  // () {
  //     runApp( MyApp());
  // },
  // blocObserver: MyBlocObserver(),
//  );
}
