import 'dart:developer';

import 'package:dio/dio.dart';

import 'apis.dart';

class DioHelper {
  static Dio? dio;

 

  static init() {
 

    dio = Dio(BaseOptions(
     
      baseUrl: APIS().baseUrl,
      receiveDataWhenStatusError: true,
      headers: {"Accept": "application/json"},
    ));
  }

  //make method is static to access without create object from class
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
  }) async {
    if (header != null) {
      dio!.options.headers = header;
    }

    print('Get URL = =' + dio!.options.baseUrl + url);
    // // };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    Map<String, dynamic>? body,
  }) async {
    if (header != null) {
      dio!.options.headers = header;
    }
    log('Headers== ' + dio!.options.headers.toString());

    log('Post URL = =' + dio!.options.baseUrl + url);

    return await dio!.post(url, queryParameters: query, data: body);
  }

  static Future<Response> getDataWithoutBaseUrl({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
  }) async {
  if (header != null) {
      dio!.options.headers = header;
    }
    dio!.options.baseUrl = '';

    print('Get URL = =' + dio!.options.baseUrl + url);
    // // };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    Map<String, dynamic>? body,
  }) async {
    if (header != null) {
      dio!.options.headers = header;
    }
    log('Headers== ' + dio!.options.headers.toString());

    log('Post URL = =' + dio!.options.baseUrl + url);

    return await dio!.put(url, queryParameters: query, data: body);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? header,
    Map<String, dynamic>? body,
  }) async {
     if (header != null) {
      dio!.options.headers = header;
    }
    log('Headers== ' + dio!.options.headers.toString());
    dio!.options.baseUrl = APIS().baseUrl;

    log('Post URL = =' + dio!.options.baseUrl + url);

    return await dio!.delete(dio!.options.baseUrl + url);
  }
}
