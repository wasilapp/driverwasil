import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum toastStates { ERROR, WARRING, SUCESS }

Color? toastColor({toastStates? state}) {
  Color? color;
  switch (state) {
    case toastStates.ERROR:
      color = Color.fromRGBO(245, 3, 3, 0.6470588235294118).withOpacity(.8);
      break;
    case toastStates.SUCESS:
      color = primaryColor;
      break;
    case toastStates.WARRING:
      color = Color.fromRGBO(245, 70, 1, 0.6980392156862745).withOpacity(.8);
      break;
  }
  return color;
}

void showtoast({required String text, required toastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: toastColor(state: state),
        textColor: Colors.white,
        fontSize: 16.0);
