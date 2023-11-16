import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CutemTextFaild extends StatelessWidget {
  TextEditingController controler;
  TextStyle? inputStyle;
  TextStyle? hintStyle;
  TextStyle? lableStyle;
  String? hint;
  InputBorder? border;
  bool? isPassword;
  bool? enbleBorder;

  Widget? lable;
  Color? fillColor;
  bool? useFillColor;
  Widget? prfxIcon;
  Widget? sufxIcon;

  CutemTextFaild(
      {Key? key,
      required this.controler,
      this.border,
      this.inputStyle,
      this.hintStyle,
      this.lableStyle,
      this.hint,
      this.lable,
      this.fillColor,
      this.enbleBorder,
      this.useFillColor,
      this.isPassword,
      this.sufxIcon,
      this.prfxIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controler,
      obscureText: isPassword ?? false,
      style: inputStyle ??TextStyle(),
      decoration: InputDecoration(
        fillColor: fillColor ?? null,
        filled: useFillColor ?? false,
        label: lable ?? null,
        enabledBorder: enbleBorder == false
            ? null
            : border ,
        hintStyle: hintStyle ?? null,
        prefix: prfxIcon ?? null,
        suffix: sufxIcon ?? null,
        labelStyle: lableStyle ?? null,
      ),
    );
  }
}
