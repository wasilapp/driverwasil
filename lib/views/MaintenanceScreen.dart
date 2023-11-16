import 'package:DeliveryBoyApp/controllers/AuthController.dart';
import 'package:DeliveryBoyApp/controllers/MaintenanceController.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/utils/UrlUtils.dart';
import 'package:DeliveryBoyApp/views/order/order_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppTheme.dart';
import '../AppThemeNotifier.dart';
import 'AppScreen.dart';
import 'auth/LoginScreen.dart';
import 'auth/OTPVerificationScreen.dart';


class MaintenanceScreen extends StatefulWidget {

  final bool isNeedUpdate;

  const MaintenanceScreen({Key? key, this.isNeedUpdate=false}) : super(key: key);


  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {

  //ThemeData
  late ThemeData themeData;
  bool isInProgress = false;

  //Variables
  late bool isNeedUpdate;


  @override
  void initState() {
    super.initState();
    isNeedUpdate = widget.isNeedUpdate;
  }
  //Global Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = new GlobalKey<ScaffoldMessengerState>();




  _checkMaintenance() async {
    setState(() {
      isInProgress = true;
    });

    MyResponse myResponse = await MaintenanceController.checkMaintenance();


    if (myResponse.success) {
      AuthType authType = await AuthController.userAuthType();

      if (authType == AuthType.VERIFIED) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );
      }
      // else if (authType == AuthType.LOGIN) {
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => OTPVerificationScreen(),
      //     ),
      //         (route) => false,
      //   );
      // }
      else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      }
    } else {
      showMessage(message: "Please wait for some time");
    }

    setState(() {
      isInProgress = false;
    });
  }

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return MaterialApp(
          scaffoldMessengerKey: _scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: SafeArea(
              child: Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: themeData.backgroundColor,
                  body: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MySize.size3,
                          child: isInProgress
                              ? LinearProgressIndicator(
                            minHeight: MySize.size3,
                          )
                              : Container(
                            height: MySize.size3,
                          ),
                        ),
                        Container(
                          child: Image(
                            image: AssetImage('./assets/images/maintenance.png'),
                          ),
                        ),


                        !isNeedUpdate ? Column(
                          children: [
                            Container(
                              margin: Spacing.top(24),
                              child: Text(
                                Translator.translate("we_will_be_back_soon"),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 600,
                                    letterSpacing: 0.2),
                              ),
                            ),
                            Container(
                              margin: Spacing.fromLTRB(24,24,24,0),
                              child: Text(
                                "If you found bugs then uninstall app and re install application or contact to admin",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 500),textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                                margin: Spacing.only(
                                    left: MySize.size56,
                                    right: MySize.size56,
                                    top: MySize.size24!),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(Spacing.xy(24,12)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius:  BorderRadius.circular(4),
                                      ))
                                  ),  onPressed: () {
                                  _checkMaintenance();
                                },
                                  child: Text(
                                    Translator.translate("refresh"),
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText1,
                                        color: themeData.colorScheme.onPrimary),
                                  ),
                                ))
                          ],
                        ):Column(
                          children: [
                            Container(
                              margin: Spacing.top(24),
                              child: Text(
                                Translator.translate("you_need_update_application"),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 600,
                                    letterSpacing: 0.2),
                              ),
                            ),
                            Container(
                              margin: Spacing.fromLTRB(24,24,24,0),
                              child: Text(
                                "Please download our latest version and enjoy",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    color: themeData.colorScheme.onBackground,
                                    fontWeight: 500),textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                                margin: Spacing.only(
                                    left: MySize.size56,
                                    right: MySize.size56,
                                    top: MySize.size24!),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(Spacing.xy(24,12)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius:  BorderRadius.circular(4),
                                      ))
                                  ), onPressed: () {
                                  UrlUtils.openDocsDownloadPage();
                                },
                                  child: Text(
                                    Translator.translate("download"),
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText1,
                                        color: themeData.colorScheme.onPrimary),
                                  ),
                                ))
                          ],
                        )

                      ],
                    ),
                  )),
            ));
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
