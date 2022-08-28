import 'package:flutter/material.dart';
import 'package:weather/presentation/resources/color_manager.dart';

class SearchField extends StatelessWidget {
  TextEditingController controller;
  Function? onChanged;
  Widget? suffixIcon;
  SearchField(
      {Key? key, required this.controller, this.suffixIcon, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.grey.shade800),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      decoration: InputDecoration(
        //contentPadding: const EdgeInsets.symmetric(vertical: 5),
        filled: true,
        fillColor: const Color(0xffF3F5F9),
        prefixIcon:  Icon(
          Icons.search_rounded,
          color: ColorManager.lightGrey,
        ),
        suffixIcon: suffixIcon,
    
      ),
    );
  }
}
