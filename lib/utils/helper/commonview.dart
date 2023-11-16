import 'package:flutter/material.dart';

import '../colors.dart';
import '../ui/deivertext.dart';

class CommonViews {
  static final CommonViews _shared = CommonViews._private();

  factory CommonViews() => _shared;

  CommonViews._private();

  // singleton Ready

  AppBar getAppBar({
    String? title,
    Color? color,

    IconData?icon
    ,Widget ? action
  }) {
    return
      AppBar(
          actions: [


            //
            Padding(padding: EdgeInsets.only(right: 20),
                child: action )
          ],
          backgroundColor: color ?? Colors.white,
          elevation: 0,
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(25))),
          title: DriverText(title: title??'', ),
          centerTitle: true);
  }

  Widget createButton(
      {required String title, required VoidCallback onPressed}) {
    return ElevatedButton(

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor:primaryColor,
            minimumSize: const Size(300, 55),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),

        child: DriverText(
          title: title,
          textColor: Colors.white,

          fontSize: 18,
          fontWeight: FontWeight.w600,

        ));
  }
}