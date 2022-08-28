import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather/data/singleton.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());


  void filterSearchList(String enteredKeyword) {
    List<String>   searchResult=[];
    if (enteredKeyword.isNotEmpty) {
      searchResult = Singleton().cities
          .where((element) => element
          .toLowerCase()
          .startsWith(enteredKeyword.trimRight().toLowerCase()))
          .toList();
    }
    emit(CityResult(searchResult));
  }
}
