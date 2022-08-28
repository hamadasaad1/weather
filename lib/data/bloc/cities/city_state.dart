part of 'city_cubit.dart';

@immutable
abstract class CityState {}

class CityInitial extends CityState {}
class CityResult extends CityState {
 final  List<String> searchResult;

  CityResult(this.searchResult);
}
