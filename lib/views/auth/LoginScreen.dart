// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:DeliveryBoyApp/utils/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


import 'package:DeliveryBoyApp/controllers/AuthController.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/utils/Validator.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import '../AppScreen.dart';
import 'ForgotPasswordScreen.dart';
import 'OTPVerificationScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
 final bool fromRegister;
  const LoginScreen({
    Key? key,
     this.fromRegister=false,
  }) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //ThemeData
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  //Text Field Editing Controller
  TextEditingController? emailTFController;
  TextEditingController? passwordTFController;

  //Global Key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = new GlobalKey<ScaffoldMessengerState>();
 TextEditingController? _numberController;

  //Other Variable
  late bool isInProgress;
  OutlineInputBorder? allTFBorder;
  bool showPassword = false;

   String contrycode ="962";

  @override
  void initState() {
    super.initState();
    if(widget.fromRegister==false){
         _checkUserLoginOrNot();
    }
 

    isInProgress = false;
    emailTFController = TextEditingController(text:"");
    passwordTFController = TextEditingController(text:"");
        _numberController = TextEditingController();
  }

  _checkUserLoginOrNot() async {
    AuthType authType = await AuthController.userAuthType();
    if (authType == AuthType.VERIFIED) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AppScreen(),
        ),
            (route) => false,
      );
    } else if (authType == AuthType.LOGIN) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OTPVerificationScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  void dispose() {
    emailTFController!.dispose();
    passwordTFController!.dispose();
    super.dispose();
  }

  _initUI() {
    allTFBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: customAppTheme.bgLayer4, width: 1.5));
  }

  _handleLogin() async {
    String mobile = _numberController!.text;
    String password = passwordTFController!.text;

    if (mobile.isEmpty) {
      showMessage(message: Translator.translate("please_fill_mobile"));
    } else if (password.isEmpty) {
      showMessage(message: Translator.translate("please_fill_password"));
    } else {
      if (mounted) {
        setState(() {
          isInProgress = true;
        });
      }
      log("${contrycode+mobile}");
      log("sss");
      MyResponse response = await AuthController.loginUser("+"+contrycode+mobile, password);
      log(response.data.toString());
      log("sss");
      AuthType authType = await AuthController.userAuthType();

      if (mounted) {
        setState(() {
          isInProgress = false;
        });
      }

      if (authType == AuthType.VERIFIED) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AppScreen(),
          ),
        );
      } else if (authType == AuthType.LOGIN) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => OTPVerificationScreen(),
          ),
        );
      }  else {
        //ApiUtil.checkRedirectNavigation(context, response.responseCode);
        print(response.errorText);
        showMessage(message: response.errorText);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        _initUI();
        return MaterialApp(
          scaffoldMessengerKey: _scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                key: _scaffoldKey,
                body: Container(
                    color: customAppTheme.bgLayer1,
                    child: ListView(
                      padding: Spacing.top(120),
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            'assets/images/logo.png',
                           // color: themeData.colorScheme.primary,
                            width: 54,
                            height: 54,
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: Spacing.top(24),
                            child: Text(
                              Translator.translate("welcome_back!").toUpperCase(),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 700,
                                  letterSpacing: 0.5),
                            ),
                          ),
                        ),
               SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right:20,left: 20),
                child: Row(
                                  children: [
                                    ElevatedButton(

                                      onPressed: () {
                                        showCountryPicker(
                                          context: context,
                                          //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                          exclude: <String>['KN', 'MF'],
                                          favorite: <String>['SE'],
                                          //Optional. Shows phone code before the country name.
                                          showPhoneCode: true,
                                          onSelect: (Country country) {
                                            setState(() {
                                              contrycode = country.phoneCode;
                                            });
                                            print(
                                                'Select country: ${country.displayName}');
                                          },
                                          // Optional. Sets the theme for the country list picker.
                                          countryListTheme: CountryListThemeData(
                                            // Optional. Sets the border radius for the bottomsheet.
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40.0),
                                              topRight: Radius.circular(40.0),
                                            ),
                                            // Optional. Styles the search field.
                                            inputDecoration: InputDecoration(
                                              labelText: 'Search',
                                              hintText: 'Start typing to search',
                                              prefixIcon:
                                              const Icon(Icons.search),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: const Color(0xFF8C98A8)
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                            ),
                                            // Optional. Styles the text in the search field
                                            searchTextStyle: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                            ),
                                          ),
                                        );
                                      },
                                      child:  Text(contrycode,style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                                    ),
                                    Spacing.width(8),
                                    Expanded(
                                      child: TextFormField(
                                        style: AppTheme.getTextStyle(
                                            themeData.textTheme.bodyText1,
                                            letterSpacing: 0.1,
                                            color: themeData
                                                .colorScheme.onBackground,
                                            fontWeight: 500),
                                        decoration: InputDecoration(
                                            hintText: Translator.translate(
                                                "mobile_number"),
                                            hintStyle: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                letterSpacing: 0.1,
                                                color: themeData
                                                    .colorScheme.onBackground,
                                                fontWeight: 500),
                                            border: allTFBorder,
                                            enabledBorder: allTFBorder,
                                            focusedBorder: allTFBorder,
                                            prefixIcon: Icon(
                                              MdiIcons.phone,
                                              size: MySize.size22,
                                            ),
                                            isDense: true,
                                            contentPadding: Spacing.zero),
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        textCapitalization:
                                        TextCapitalization.sentences,
                                        controller: _numberController,
                                      ),
                                    ),
                                  ],
                                ),
              ),

              SizedBox(height: 20,),
                        Container(
                          margin: Spacing.fromLTRB(24,16,24,0),
                          child: TextFormField(
                            obscureText: showPassword,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              hintStyle: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  letterSpacing: 0.1,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              hintText: Translator.translate("password"),
                              border: allTFBorder,
                              enabledBorder: allTFBorder,
                              focusedBorder: allTFBorder,
                              prefixIcon: Icon(
                                MdiIcons.lockOutline,
                                size: 22,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                child: Icon(
                                  showPassword
                                      ? MdiIcons.eyeOutline
                                      : MdiIcons.eyeOffOutline,
                                  size: MySize.size22,
                                ),
                              ),
                              isDense: true,
                              contentPadding: Spacing.zero,
                            ),
                            controller: passwordTFController,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        Container(
                          margin: Spacing.fromLTRB(24,8,24,0),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                            },
                            child: Text(
                              Translator.translate("forgot_password") + " ?",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText2,
                                  fontWeight: 500),
                            ),
                          ),
                        ),
                        Container(
                          margin: Spacing.fromLTRB(24,24,24,0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(primaryColor),
                                padding: MaterialStateProperty.all(Spacing.xy(24,12)),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(4),
                                ))
                            ),
                            onPressed: () {
                              if(!isInProgress){
                                _handleLogin();
                              }
                            },
                            child: Stack(
                              clipBehavior: Clip.none, alignment: Alignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    Translator.translate("log_in").toUpperCase(),
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        color: themeData
                                            .colorScheme.onPrimary,
                                        letterSpacing: 0.8,
                                        fontWeight: 700),
                                  ),
                                ),
                                Positioned(
                                  right: 16,
                                  child: isInProgress
                                      ? Container(
                                          width: MySize.size16,
                                          height: MySize.size16,
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                          Color>(
                                                      themeData
                                                          .colorScheme
                                                          .onPrimary),
                                              strokeWidth: 1.4),
                                        )
                                      : ClipOval(
                                          child: Container(
                                            // color: themeData.colorScheme
                                            //     .primaryVariant,
                                            child: SizedBox(
                                                width: MySize.size30,
                                                height: MySize.size30,
                                                child: Icon(
                                                  MdiIcons.arrowRight,
                                                  color: themeData
                                                      .colorScheme
                                                      .onPrimary,
                                                  size: MySize.size18,
                                                )),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: Spacing.top(16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()));
                              },
                              child: Text(
                                Translator.translate("i_have_not_an_account"),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 500,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))));
      },
    );
  }

  void showMessage({String message = "Something wrong", Duration? duration}) {
    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(message,
            style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
                letterSpacing: 0.4, color: themeData.colorScheme.onPrimary)),
        backgroundColor: themeData.colorScheme.primary,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
