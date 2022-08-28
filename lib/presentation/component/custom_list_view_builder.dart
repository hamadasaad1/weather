import 'package:flutter/material.dart';
import 'package:weather/presentation/resources/styles_manager.dart';

class CustomListViewBuilder extends StatelessWidget {
  List<String> itemsList;
  Function onTap;
  Color textColor;
  bool makeDivider;

  CustomListViewBuilder(
      {Key? key,
      required this.itemsList,
      required this.onTap,
      required this.textColor,
      this.makeDivider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) =>
            makeDivider ? const Divider(color: Colors.grey) : const SizedBox(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        itemCount: itemsList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                onTap(context, index);
              },
              title: Text(
                itemsList[index],
                style: getRegularStyle(fontSize: 18, color: textColor),
              ),
            ));
  }
}
