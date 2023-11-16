import 'dart:developer';
import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:DeliveryBoyApp/views/auth/RegisterScreen.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';
import 'package:DeliveryBoyApp/views/order/order_view.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../services/AppLocalizations.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/ui/textfeild.dart';
import '../AppScreen.dart';






class LoginScreen extends StatefulWidget {


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Text-Field Controller
  TextEditingController? passwordTFController;
  TextEditingController? _numberController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  String countryCode = "962";


  @override
  void initState() {
    super.initState();
    passwordTFController = TextEditingController();
    _numberController = TextEditingController();
  }

  @override
  void dispose() {
    _numberController!.dispose();
    passwordTFController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthControllerr controller=Get.put(AuthControllerr());
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: Spacing.top(150),
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120.0,
                    height: 120.0,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 2.0.w),
                      child: Text(
                        Translator.translate("Sign in"),
                        style: boldPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),


                    Spacing.width(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    countryCode = country.phoneCode;
                                  });
                                  log('Select country: $countryCode');
                                },
                                // Optional. Sets the theme for the country list picker.
                                countryListTheme: CountryListThemeData(
                                  // Optional. Sets the border radius for the bottomsheet.
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40.0),
                                    topRight: Radius.circular(40.0),
                                  ),
                                  // Optional. Styles the search field.
                                  inputDecoration: InputDecoration(
                                    labelText: 'Search',
                                    hintText: 'Start typing to search',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8C98A8)
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                  // Optional. Styles the text in the search field
                                  searchTextStyle: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                            child: Text(countryCode,
                                style: const TextStyle(color: Colors.white)),
                          ),
                          Spacing.width(8),
                          Expanded(
                              child: CustomTextField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return   Translator.translate('Please enter your mobile number');
                                  }
                                  if (value.length != 9) {
                                    return   Translator.translate('mobile number not equal 9');
                                  }
                                },
                                hintText:   Translator.translate('mobile Number'),
                                controller: _numberController!,
                                prefixIconData: Icon(Icons.phone_android),
                                keyBoard: TextInputType.number,
                              )),
                        ],
                      ),
                    ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return   Translator.translate('Please enter your  password');
                    }
                    if (value.length <= 8) {
                      return   Translator.translate('password length at least 8 character');
                    }
                  },
                  keyBoard: TextInputType.text,
                  controller: passwordTFController!,
                  isPassword: showPassword,
                  hintText: Translator.translate("password"),
                  prefixIconData: Icon(Icons.lock_outline),
                  onPrefixIconPress: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
                TextButton(
                  style: const ButtonStyle(alignment: Alignment.bottomRight),
                  onPressed: () {},
                  //    MangerNavigator.of(context).push(const ForgetPassword()),
                  child: Text(
                    "${Translator.translate("forget password ?")} ",
                  ),
                ),
      Obx(() =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:   Text(
            controller.erroeText.value,
            style: const TextStyle(
              color: Colors.red,overflow: TextOverflow.ellipsis,
            ),      softWrap: false,maxLines: 2,

          ),),



      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      log('nott');
                      if (_formKey.currentState!.validate()) {
                        controller.loginUser(countryCode.toString()+_numberController!.text, passwordTFController!.text);
                      }},
                        // log('not');
                        // log(countryCode.toString() + _numberController!.text);
                        //
                        // final dio = Dio(); // Create a Dio instance
                        //
                        // final formData = FormData();
                        //
                        // // Define the API endpoint URL
                        // const url =
                        //     "https://news.wasiljo.com/public/api/v1/delivery-boy/login";
                        //
                        // // Define the request headers
                        //
                        //
                        // // Define the request data (payload)
                        // formData.fields.addAll([
                        //   MapEntry('password', passwordTFController!.text),
                        //   MapEntry('mobile',
                        //      _numberController!.text),
                        // ]);
                        //
                        // try {
                        //   final response = await dio.post(
                        //     url,
                        //     data: formData,
                        //
                        //   );
                        //
                        //   if (response.statusCode == 200) {SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        //
                        //     setState(() {
                        //       prefs.setString(
                        //           'token', response.data['data']['token']);
                        //       log('${prefs.getString('token')}');
                        //  errorMessages.clear();
                        //     });
                        //
                        //
                        //     log("Response data: ${response.data}");
                        //     DriverNavigator.of(context)
                        //         .pushReplacement( HomeScreen());
                        //   }
                    //     }
                    //     on DioException   catch (e) {
                    //       print("o");
                    //       print(e.response!.data['errors'][0]);
                    //       print(e.response);
                    //       setState(() {
                    //         errorMessages =
                    //         List<String>.from(e.response!.data['errors']);
                    //       });
                    //     }
                    //   }
                    // },
                    child: Text(       Translator.translate("Sign in"),
                      style: const TextStyle(color: Colors.white),

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
                                builder: (context) =>  RegisterScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Translator.translate("Don't have an Account?"),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            Translator.translate("SignUp"),
                            style: basicPrimary,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // InkWell(
                //   onTap: () {
                //    // pushScreen(context, const homepage());
                //   },
                //   child: Center(
                //     child: Text(
                //       Translator.translate("SignIn with vistor "),
                //     ),
                //   ),
                // ),
              ]),
            ));
  }
}


// import 'dart:developer';
//
// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';
//
// import 'package:DeliveryBoyApp/api/api_util.dart';
// import 'package:DeliveryBoyApp/controllers/AuthController.dart';
// import 'package:DeliveryBoyApp/models/MyResponse.dart';
// import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
// import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
// import 'package:DeliveryBoyApp/utils/Validator.dart';
//
// import '../../AppTheme.dart';
// import '../../AppThemeNotifier.dart';
// import '../AppScreen.dart';
// import 'ForgotPasswordScreen.dart';
// import 'OTPVerificationScreen.dart';
// import 'RegisterScreen.dart';

// class LoginScreen extends StatefulWidget {
//   final bool fromRegister;
//   const LoginScreen({
//     Key? key,
//     this.fromRegister=false,
//   }) : super(key: key);
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//
//   //ThemeData
//   late ThemeData themeData;
//   late CustomAppTheme customAppTheme;
//
//   //Text Field Editing Controller
//   TextEditingController? emailTFController;
//   TextEditingController? passwordTFController;
//
//   //Global Key
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = new GlobalKey<ScaffoldMessengerState>();
//   TextEditingController? _numberController;
//
//   //Other Variable
//   late bool isInProgress;
//   OutlineInputBorder? allTFBorder;
//   bool showPassword = false;
//
//   String contrycode ="962";
//
//   @override
//   void initState() {
//     super.initState();
//     if(widget.fromRegister==false){
//       _checkUserLoginOrNot();
//     }
//
//
//     isInProgress = false;
//     emailTFController = TextEditingController(text:"");
//     passwordTFController = TextEditingController(text:"");
//     _numberController = TextEditingController();
//   }
//
//   _checkUserLoginOrNot() async {
//     AuthType authType = await AuthController.userAuthType();
//     if (authType == AuthType.VERIFIED) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) => AppScreen(),
//         ),
//             (route) => false,
//       );
//     } else if (authType == AuthType.LOGIN) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) => OTPVerificationScreen(),
//         ),
//             (route) => false,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     emailTFController!.dispose();
//     passwordTFController!.dispose();
//     super.dispose();
//   }
//
//   _initUI() {
//     allTFBorder = OutlineInputBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(8),
//         ),
//         borderSide: BorderSide(color: customAppTheme.bgLayer4, width: 1.5));
//   }
//   AuthController authController=Get.put(AuthController());
//   _handleLogin() async {
//     String mobile = _numberController!.text;
//     String password = passwordTFController!.text;
//
//     if (mobile.isEmpty) {
//       showMessage(message: Translator.translate("please_fill_mobile"));
//     } else if (password.isEmpty) {
//       showMessage(message: Translator.translate("please_fill_password"));
//     } else {
//       if (mounted) {
//         setState(() {
//           isInProgress = true;
//         });
//       }
//       log("${contrycode+mobile}");
//       MyResponse response = await authController.loginUser("+"+contrycode+mobile, password);
//       log(response.data.toString());
//       AuthType authType = await AuthController.userAuthType();
//
//       if (mounted) {
//         setState(() {
//           isInProgress = false;
//         });
//       }
//
//       if (authType == AuthType.VERIFIED) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) => AppScreen(),
//           ),
//         );
//       } else if (authType == AuthType.LOGIN) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) => OTPVerificationScreen(),
//           ),
//         );
//       }  else {
//         //ApiUtil.checkRedirectNavigation(context, response.responseCode);
//         showMessage(message: response.errorText);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppThemeNotifier>(
//       builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
//         int themeType = value.themeMode();
//         themeData = AppTheme.getThemeFromThemeMode(themeType);
//         customAppTheme = AppTheme.getCustomAppTheme(themeType);
//         _initUI();
//         return MaterialApp(
//             scaffoldMessengerKey: _scaffoldMessengerKey,
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
//             home: Scaffold(
//                 key: _scaffoldKey,
//                 body: Container(
//                     color: customAppTheme.bgLayer1,
//                     child: ListView(
//                       padding: Spacing.top(120),
//                       children: <Widget>[
//                         Container(
//                           child: Image.asset(
//                             'assets/images/logo.png',
//                             // color: themeData.colorScheme.primary,
//                             width: 54,
//                             height: 54,
//                           ),
//                         ),
//                         Center(
//                           child: Container(
//                             margin: Spacing.top(24),
//                             child: Text(
//                               Translator.translate("welcome_back!").toUpperCase(),
//                               style: AppTheme.getTextStyle(
//                                   themeData.textTheme.headline6,
//                                   color: themeData.colorScheme.onBackground,
//                                   fontWeight: 700,
//                                   letterSpacing: 0.5),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20,),
//                         Padding(
//                           padding: const EdgeInsets.only(right:20,left: 20),
//                           child: Row(
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   showCountryPicker(
//                                     context: context,
//                                     //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
//                                     exclude: <String>['KN', 'MF'],
//                                     favorite: <String>['SE'],
//                                     //Optional. Shows phone code before the country name.
//                                     showPhoneCode: true,
//                                     onSelect: (Country country) {
//                                       setState(() {
//                                         contrycode = country.phoneCode;
//                                       });
//                                       print(
//                                           'Select country: ${country.displayName}');
//                                     },
//                                     // Optional. Sets the theme for the country list picker.
//                                     countryListTheme: CountryListThemeData(
//                                       // Optional. Sets the border radius for the bottomsheet.
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(40.0),
//                                         topRight: Radius.circular(40.0),
//                                       ),
//                                       // Optional. Styles the search field.
//                                       inputDecoration: InputDecoration(
//                                         labelText: 'Search',
//                                         hintText: 'Start typing to search',
//                                         prefixIcon:
//                                         const Icon(Icons.search),
//                                         border: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                             color: const Color(0xFF8C98A8)
//                                                 .withOpacity(0.2),
//                                           ),
//                                         ),
//                                       ),
//                                       // Optional. Styles the text in the search field
//                                       searchTextStyle: TextStyle(
//                                         color: Colors.green,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child:  Text(contrycode),
//                               ),
//                               Spacing.width(8),
//                               Expanded(
//                                 child: TextFormField(
//                                   style: AppTheme.getTextStyle(
//                                       themeData.textTheme.bodyText1,
//                                       letterSpacing: 0.1,
//                                       color: themeData
//                                           .colorScheme.onBackground,
//                                       fontWeight: 500),
//                                   decoration: InputDecoration(
//                                       hintText: Translator.translate(
//                                           "mobile_number"),
//                                       hintStyle: AppTheme.getTextStyle(
//                                           themeData.textTheme.subtitle2,
//                                           letterSpacing: 0.1,
//                                           color: themeData
//                                               .colorScheme.onBackground,
//                                           fontWeight: 500),
//                                       border: allTFBorder,
//                                       enabledBorder: allTFBorder,
//                                       focusedBorder: allTFBorder,
//                                       prefixIcon: Icon(
//                                         MdiIcons.phone,
//                                         size: MySize.size22,
//                                       ),
//                                       isDense: true,
//                                       contentPadding: Spacing.zero),
//                                   keyboardType: TextInputType.number,
//                                   autofocus: false,
//                                   textCapitalization:
//                                   TextCapitalization.sentences,
//                                   controller: _numberController,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: 20,),
//                         Container(
//                           margin: Spacing.fromLTRB(24,16,24,0),
//                           child: TextFormField(
//                             obscureText: showPassword,
//                             style: AppTheme.getTextStyle(
//                                 themeData.textTheme.bodyText1,
//                                 letterSpacing: 0.1,
//                                 color: themeData.colorScheme.onBackground,
//                                 fontWeight: 500),
//                             decoration: InputDecoration(
//                               hintStyle: AppTheme.getTextStyle(
//                                   themeData.textTheme.subtitle2,
//                                   letterSpacing: 0.1,
//                                   color: themeData.colorScheme.onBackground,
//                                   fontWeight: 500),
//                               hintText: Translator.translate("password"),
//                               border: allTFBorder,
//                               enabledBorder: allTFBorder,
//                               focusedBorder: allTFBorder,
//                               prefixIcon: Icon(
//                                 MdiIcons.lockOutline,
//                                 size: 22,
//                               ),
//                               suffixIcon: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     showPassword = !showPassword;
//                                   });
//                                 },
//                                 child: Icon(
//                                   showPassword
//                                       ? MdiIcons.eyeOutline
//                                       : MdiIcons.eyeOffOutline,
//                                   size: MySize.size22,
//                                 ),
//                               ),
//                               isDense: true,
//                               contentPadding: Spacing.zero,
//                             ),
//                             controller: passwordTFController,
//                             keyboardType: TextInputType.visiblePassword,
//                           ),
//                         ),
//                         Container(
//                           margin: Spacing.fromLTRB(24,8,24,0),
//                           alignment: Alignment.centerRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           ForgotPasswordScreen()));
//                             },
//                             child: Text(
//                               Translator.translate("forgot_password") + " ?",
//                               style: AppTheme.getTextStyle(
//                                   themeData.textTheme.bodyText2,
//                                   fontWeight: 500),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: Spacing.fromLTRB(24,24,24,0),
//                           child: ElevatedButton(
//                             style: ButtonStyle(
//                                 padding: MaterialStateProperty.all(Spacing.xy(24,12)),
//                                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                                   borderRadius:  BorderRadius.circular(4),
//                                 ))
//                             ),
//                             onPressed: () {
//                               if(!isInProgress){
//                                 _handleLogin();
//                               }
//                             },
//                             child: Stack(
//                               clipBehavior: Clip.none, alignment: Alignment.center,
//                               children: <Widget>[
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     Translator.translate("log_in").toUpperCase(),
//                                     style: AppTheme.getTextStyle(
//                                         themeData.textTheme.bodyText2,
//                                         color: themeData
//                                             .colorScheme.onPrimary,
//                                         letterSpacing: 0.8,
//                                         fontWeight: 700),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: 16,
//                                   child: isInProgress
//                                       ? Container(
//                                     width: MySize.size16,
//                                     height: MySize.size16,
//                                     child: CircularProgressIndicator(
//                                         valueColor:
//                                         AlwaysStoppedAnimation<
//                                             Color>(
//                                             themeData
//                                                 .colorScheme
//                                                 .onPrimary),
//                                         strokeWidth: 1.4),
//                                   )
//                                       : ClipOval(
//                                     child: Container(
//                                       // color: themeData.colorScheme
//                                       //     .primaryVariant,
//                                       child: SizedBox(
//                                           width: MySize.size30,
//                                           height: MySize.size30,
//                                           child: Icon(
//                                             MdiIcons.arrowRight,
//                                             color: themeData
//                                                 .colorScheme
//                                                 .onPrimary,
//                                             size: MySize.size18,
//                                           )),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Container(
//                             margin: Spacing.top(16),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => RegisterScreen()));
//                               },
//                               child: Text(
//                                 Translator.translate("i_have_not_an_account"),
//                                 style: AppTheme.getTextStyle(
//                                     themeData.textTheme.bodyText2,
//                                     color: themeData.colorScheme.onBackground,
//                                     fontWeight: 500,
//                                     decoration: TextDecoration.underline),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ))));
//       },
//     );
//   }
//
//   void showMessage({String message = "Something wrong", Duration? duration}) {
//     if (duration == null) {
//       duration = Duration(seconds: 3);
//     }
//     _scaffoldMessengerKey.currentState!.showSnackBar(
//       SnackBar(
//         duration: duration,
//         content: Text(message,
//             style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
//                 letterSpacing: 0.4, color: themeData.colorScheme.onPrimary)),
//         backgroundColor: themeData.colorScheme.primary,
//         behavior: SnackBarBehavior.fixed,
//       ),
//     );
//   }
// }
