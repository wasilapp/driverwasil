import 'dart:developer';

import 'package:DeliveryBoyApp/controllers/AppDataController.dart';
import 'package:DeliveryBoyApp/firebase_options.dart';
import 'package:DeliveryBoyApp/models/DeliveryBoy.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/services/PushNotificationsManager.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/views/MaintenanceScreen.dart';
import 'package:DeliveryBoyApp/views/auth/login/LoginScreen.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';
import 'package:DeliveryBoyApp/views/order/order_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'AppTheme.dart';
import 'AppThemeNotifier.dart';
import 'api/api_util.dart';
import 'controllers/AuthController.dart' as con;
import 'models/AppData.dart';
import 'models/MyResponse.dart';

String token = '';
DeliveryBoy? user;
final storage = GetStorage();
Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  //android apk   ios IPA   account apple -> apple developer account  -> enroll 100$  74jod  MAC  Xocde ->   developerAccount -> testflight !linkable
  //Setup Push Notification for your device

  String langCode = await AllLanguage.getLanguage();
  await Translator.load(langCode);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  token = sharedPreferences.get('token').toString();
  log('my token ==>$token');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) async {
      runApp(
        ChangeNotifierProvider<AppThemeNotifier>(
          create: (context) => AppThemeNotifier(),
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
        builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            locale: Locale('ar'),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: MyHomePage(),
          );
        },
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeData? themeData;
  AuthControllerr controller = Get.put(AuthControllerr());

  @override
  void initState() {
    super.initState();
    getAppData();
    // initFCM();
  }

  getAppData() async {
    MyResponse<AppData> myResponse = await AppDataController.getAppData();
    user = await con.AuthController.getUser();
    if (myResponse.data != null) {
      if (myResponse.data!.deliveryBoy != null) {
        print(myResponse.data!.deliveryBoy!.mobile);
        controller.saveUserFromDeliveryBoy(myResponse.data!.deliveryBoy!);
      }

      if (!myResponse.data!.isAppUpdated()) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MaintenanceScreen(
              isNeedUpdate: true,
            ),
          ),
          (route) => false,
        );
        return;
      } else {
        ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      }
    } else {
      ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
    }
  }

  initFCM() async {
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AuthControllerr());
    AuthControllerr controller = Get.put(AuthControllerr());
    MySize().init(context);
    themeData = Theme.of(context);
    return FutureBuilder<AuthType>(
        future: controller.userAuthType(),
        builder: (context, AsyncSnapshot<AuthType> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == AuthType.VERIFIED ||
                token.isNotEmpty == true) {
              return HomeScreen();
            } else if (snapshot.data == AuthType.LOGIN ||
                token.isNotEmpty == true) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
