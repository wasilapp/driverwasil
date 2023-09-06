import 'dart:developer';

import 'package:DeliveryBoyApp/firebase_options.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/services/PushNotificationsManager.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/views/AppScreen.dart';
import 'package:DeliveryBoyApp/views/MaintenanceScreen.dart';
import 'package:DeliveryBoyApp/views/auth/LoginScreen.dart';
import 'package:DeliveryBoyApp/views/auth/OTPVerificationScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'AppTheme.dart';
import 'AppThemeNotifier.dart';
import 'api/api_util.dart';
import 'controllers/AppDataController.dart';
import 'controllers/AuthController.dart';
import 'models/AppData.dart';
import 'models/MyResponse.dart';

Future<void> main() async {

  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  //Setup Push Notification for your device

  String langCode = await AllLanguage.getLanguage();
  await Translator.load(langCode);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {

    runApp(ChangeNotifierProvider<AppThemeNotifier>(
      create: (context) => AppThemeNotifier(),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: MyHomePage());
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeData? themeData;


  @override
  void initState() {
    super.initState();
    getAppData();
    initFCM();
  }

  getAppData() async {

      MyResponse<AppData> myResponse = await AppDataController.getAppData();

      if(myResponse.data!=null) {
        if (myResponse.data!.deliveryBoy != null) {
          AuthController.saveUserFromDeliveryBoy(myResponse.data!.deliveryBoy!);
        }


        if (!myResponse.data!.isAppUpdated()) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  MaintenanceScreen(isNeedUpdate: true,),
            ),
                (route) => false,
          );
          return;
        } else {
        ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
        }
      }else{
        ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      }



  }



  initFCM() async {
    PushNotificationsManager pushNotificationsManager = PushNotificationsManager();
    await pushNotificationsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    return FutureBuilder<AuthType>(
        future: AuthController.userAuthType(),
        builder: (context, AsyncSnapshot<AuthType> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == AuthType.VERIFIED) {
              return AppScreen();
            } else if (snapshot.data == AuthType.LOGIN) {
              return OTPVerificationScreen();
            } else {
              return LoginScreen();
            }
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
