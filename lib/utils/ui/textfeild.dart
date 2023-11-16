import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/AppLocalizations.dart';
import '../SizeConfig.dart';


class CustomTextField extends StatefulWidget {
  final String hintText;
  final Widget prefixIconData;
  final IconData? suffixIconData;
  bool isPassword;
  bool readOnly;
  final TextInputType keyBoard;
  final TextEditingController controller;
  final Function()? onPrefixIconPress;
  final Function()? press;
  final String? Function(String?)? validator;
  final TextInputFormatter? inputFormatter;

  CustomTextField(
      {
        Key? key,
        required this.hintText,
        required this.controller,
        required this.keyBoard,
        required this.prefixIconData,
        this.suffixIconData,
        //Icons.visibility_off,
        this.onPrefixIconPress,
        this.press,
        this.isPassword = false,
        this.readOnly = false,
        this.validator,
        this.inputFormatter})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  OutlineInputBorder? allTFBorder;

  _initUI() {
    allTFBorder = const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: Color(0xffdcdee3), width: 1.5));
  }

  @override
  Widget build(BuildContext context) {
    _initUI();
    return Container(
      margin: Spacing.fromLTRB(24, 16, 24, 0),
      child: TextFormField(

        keyboardType: widget.keyBoard,
        inputFormatters:
        widget.inputFormatter != null ? [widget.inputFormatter!] : null,
        // Apply the input formatter if provided
        validator: widget.validator,
        onTap: () {
          widget.press!();
        },
        readOnly: widget.readOnly,
        obscureText: widget.isPassword,
        style: const TextStyle(
            letterSpacing: 0.1,
            // color: themeData.colorScheme.onBackground,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(

          hintStyle: const TextStyle(
              letterSpacing: 0.1,
              //   color: themeData.colorScheme.onBackground,
              fontWeight: FontWeight.w500),
          hintText: Translator.translate(widget.hintText),
          border: allTFBorder,
          enabledBorder: allTFBorder,
          focusedBorder: allTFBorder,
          prefixIcon: widget.prefixIconData!,
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                // widget.isPassword = !widget.isPassword;
              });
            },
            child: Icon(
              widget.suffixIconData,
              // widget.isPassword
              //     ? MdiIcons.eyeOutline
              //     : MdiIcons.eyeOffOutline,
              size: MySize.size22,
            ),
          ),
          isDense: true,
          contentPadding: Spacing.zero,
        ),
        controller: widget.controller,
      ),
    );
  }
}

class CustomInputFormatter extends TextInputFormatter {
  final RegExp allowedCharacterSet;

  CustomInputFormatter(this.allowedCharacterSet);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow characters based on the specified allowedCharacterSet
    final filteredValue = newValue.text
        .replaceAll(RegExp('[^${allowedCharacterSet.pattern}]'), '');

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}
