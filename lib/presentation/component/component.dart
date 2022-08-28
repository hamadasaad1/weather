import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/presentation/resources/color_manager.dart';
import 'package:weather/presentation/resources/styles_manager.dart';

Future<dynamic> changeNavigator(context, widget,
    {bool isFullScreen = false}) async {
  var response = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => widget, fullscreenDialog: isFullScreen),
  );
  return response;
}

void changeNavigatorReplacement(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false,
  );
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    //backgroundColor: Color(S),
    action: SnackBarAction(
      textColor: Colors.black,
      label: 'Done',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void printApiCall(
    {String? url, String? params, String? response, String? query}) {
  debugPrint('Api Call URL=  $url??'
      ' ,\n Params= $params??'
      ' ,\n Response= $response??'
      ', ,\n Query= $query??'
      '');
}

void showSmartDialog() {
  SmartDialog.show(builder: (context) {
    return Container(
      // height: 80,
      // width: 180,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child:
          Lottie.asset('assets/lottie/weather.json', width: 200, height: 200),
    );
  });
}

Widget textField(String hintText, Function callback,
    {bool isPassword = false,
    bool isDense = true,
    VoidCallback? showPassword,
    bool isPhoneKeyboard = false,
    bool isEmailKeyboard = false,
    bool? isClicable,
    TextEditingController? controller,
    Widget? icon,
    Color? color,
    double fontSize = 16,
    Widget? prefixIcon,
    Function(String)? onChangeFunction,
    Function(String)? onVialdFunction,
    bool isSkipValidation = false,
    var autofillHints,
    double maxLines = 1}) {
  return SizedBox(
    child: TextFormField(
      enabled: isClicable,
      autofillHints: autofillHints,
      controller: controller,
      autofocus: false,
      decoration: InputDecoration(
        labelText: hintText,
        fillColor: Colors.white,
        filled: true,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    isDense ? Icons.remove_red_eye : Icons.visibility_off,
                    color: Colors.black),
                onPressed: showPassword)
            : icon,
        prefixIcon: prefixIcon != null
            ? Container(
                height: prefixIcon != null ? 30 : 0,
                width: prefixIcon != null ? 30 : 0,
                child: prefixIcon)
            : null,
      ),
      textInputAction: TextInputAction.done,
      enableSuggestions: true,
      keyboardType: isEmailKeyboard
          ? TextInputType.emailAddress
          : isPhoneKeyboard
              ? TextInputType.phone
              : TextInputType.text,
      obscureText: isPassword ? isDense : false,
      onSaved: (value) {
        callback(value);
      },
      onEditingComplete:
          autofillHints != null && autofillHints.first == 'password'
              ? () {
                  TextInput.finishAutofillContext();
                }
              : null,
      validator: (String? arg) {
        if (isSkipValidation) return null;
        if (isEmailKeyboard) {
          String p =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

          RegExp regExp = RegExp(p);
          if (!regExp.hasMatch(arg!)) {
            return 'Invalid Mail Format';
          }
        }

        if (arg!.length < 3 || arg.trim().isEmpty) {
          if (arg.trim().isEmpty) {
            controller!.text = '';
          }
          return 'Please Enter $hintText';
        } else
          return null;
      },
      onChanged: (value) {
        if (onChangeFunction == null) return;
        onChangeFunction(value);
      },
    ),
  );
}



Widget button(var onPress, String labelText,
    {bool isFilledColor = true,
    bool hasBorder = true,
    Color textColor = Colors.grey,
    double fontSize = 17,
    double roundedValue = 5,
    Color? buttonColor}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(roundedValue),
      color: !isFilledColor || !hasBorder
          ? buttonColor ?? Colors.transparent
          : ColorManager.primary,
      border: Border.all(
          color: !isFilledColor ? ColorManager.primary : Colors.transparent),
      // gradient: LinearGradient(
      //   begin: Alignment.center,
      //   end: Alignment(1, 0),
      //   colors: !isFilledColor
      //       ? [Colors.white, Colors.white]
      //       : [
      //           KPrimaryColor,
      //           Color.fromRGBO(65, 122, 177, 1),
      //         ],
      // ),
    ),
    child: MaterialButton(
      onPressed: onPress,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(roundedvalue),
      //     side: BorderSide(
      //         color: !hasBorder
      //             ? Colors.transparent
      //             : isFilledColor
      //                 ? Colors.transparent
      //                 : Colors.red)),
      // color: buttonColor != null
      //     ? buttonColor
      //     : isFilledColor
      //         ? blueColor
      //         : Colors.transparent,
      elevation: 0,
      disabledColor: Colors.grey,
      height: 50,
      child: Center(
        child: Text(labelText,
            style: getRegularStyle(
                color: isFilledColor ? Colors.white : textColor,
                fontSize: fontSize)),
      ),
    ),
  );
}

buildAppBar(BuildContext context, {VoidCallback? onPress, String? title}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    leadingWidth: 75,
    leading: InkWell(
      onTap: onPress ??
          () {
            Navigator.pop(context);
          },
      child: Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200, blurRadius: 2, spreadRadius: 1)
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          )),
    ),
    title: Text(
      title ?? '',
      style: getRegularStyle(
        fontSize: 19,
        color: Colors.white,
      ),
    ),
  );
}

String capitalization(String value) {
  if (value.length > 1) {
    return value[0].toUpperCase() + value.substring(1);
  } else {
    return value[0].toUpperCase();
  }
}
