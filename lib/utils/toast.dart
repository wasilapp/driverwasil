import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastStates { ERROR, WARRING, SUCESS }

Color? toastColor({ToastStates? state}) {
  Color? color;
  switch (state) {
    case ToastStates.ERROR:
      color = Color.fromRGBO(245, 3, 3, 0.6470588235294118).withOpacity(.8);
      break;
    case ToastStates.SUCESS:
      color = primaryColor;
      break;
    case ToastStates.WARRING:
      color = Color.fromRGBO(245, 70, 1, 0.6980392156862745).withOpacity(.8);
      break;
    case null:
      break;
  }
  return color;
}

void showtoast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: toastColor(state: state),
        textColor: Colors.white,
        fontSize: 16.0);
