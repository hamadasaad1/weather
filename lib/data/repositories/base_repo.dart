abstract class Repo {
  void handleError(WeatherError error);
// Future<void> sendAnalyticsEvent(FirebaseAnalytics analytics,String tagName, String parameter , String parameterValue);

}

class BaseRepo implements Repo {
  @override
  void handleError(WeatherError error) {
   
    print("plz handel this error>>>" + error.errorMessage!);
  }
}

class WeatherError extends Error {
  String? errorMessage;

  WeatherError({this.errorMessage});
}
