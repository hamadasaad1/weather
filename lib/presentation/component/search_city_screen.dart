import 'package:flutter/material.dart';
import 'package:weather/app/extensions.dart';
import 'package:weather/data/bloc/cities/city_cubit.dart';
import 'package:weather/data/singleton.dart';
import 'package:weather/presentation/component/search_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'component.dart';
import 'custom_list_view_builder.dart';

class SearchCityScreen extends StatelessWidget {
  SearchCityScreen({Key? key}) : super(key: key);
  TextEditingController cityController = TextEditingController();
  late CityCubit cityCubit;
  List<String> listOfCity = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CityCubit>(
      create: (context) {
        cityCubit = CityCubit();
        return cityCubit;
      },
      child: Container(
        // decoration: BoxDecoration(gradient: backgroundGradient),
        child: Scaffold(
          body: BlocConsumer<CityCubit, CityState>(
            listener: (context, state) {
              if (state is CityResult) {
                listOfCity = state.searchResult;
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/cloudy1.png",
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const Text(
                      "Enter a city",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SearchField(
                      controller: cityController,
                      suffixIcon: IconButton(
                        onPressed: () {
                          cityController.text =
                              cityController.text.capitalize().trim();
                          if (Singleton()
                              .cities
                              .contains(cityController.text)) {
                            Navigator.pop(context, cityController.text);
                          } else {
                            showSnackBar(context, 'Sorry, City not found');
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.blueGrey,
                        //minWidth: 0,
                      ),
                      onChanged: (value) {
                        cityCubit.filterSearchList(cityController.text);
                      },
                    ),
                    if (listOfCity.isNotEmpty) ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffF3F5F9),
                                borderRadius: BorderRadius.circular(5)),
                            child: CustomListViewBuilder(
                              itemsList: listOfCity,
                              textColor: Colors.grey.shade800,
                              makeDivider: true,
                              onTap: (context, index) {
                                cityController.text = listOfCity[index];
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
