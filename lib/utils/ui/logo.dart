import 'package:flutter/material.dart';

class LogoAsset extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return         Container(
      child: Image.asset(
        'assets/images/logo.png',
        width: 54,
        height: 54,
      ),
    );
  }
}
