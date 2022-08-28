import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {


  static SharedPreferences? pref;

  static void init() async {
    pref = await SharedPreferences.getInstance();
  }


  //this method to save any type data in shared
  static Future<bool> setDataToSharedPref({
    required String key,
    required dynamic value,
  }) async {
    print('Shared Value = $value');
    pref ??= await SharedPreferences.getInstance();
    if (value is String)
      return await pref!.setString(key, value); //when data string
    if (value is int) return await pref!.setInt(key, value); //when data integer
    if (value is bool)
      return await pref!.setBool(key, value); //when data boolean

    return await pref!.setDouble(key, value); //when data Double
  }

  //get dynamic data from shared
  static Future<dynamic> getDataFromSharedPref({
    required String? key,
  }) async {
    pref ??= await SharedPreferences.getInstance();
    return pref!.get(key!);
  }

  //this to remove from shared by key
  static Future<bool> deleteDataFromSharedPref({
    required String key,
  }) async {
    pref ??= await SharedPreferences.getInstance();
    return pref!.remove(key);
  }

  static Future<bool> clear() async {
    pref ??= await SharedPreferences.getInstance();
    return pref!.clear();
  }
}
