import 'dart:developer';

import 'package:DeliveryBoyApp/controllers/AppDataController.dart';
import 'package:DeliveryBoyApp/firebase_options.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/services/PushNotificationsManager.dart';
import 'package:DeliveryBoyApp/services/not.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/utils/colors.dart';
import 'package:DeliveryBoyApp/views/AppScreen.dart';
import 'package:DeliveryBoyApp/views/MaintenanceScreen.dart';
import 'package:DeliveryBoyApp/views/auth/LoginScreen.dart';
import 'package:DeliveryBoyApp/views/auth/OTPVerificationScreen.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';
import 'package:DeliveryBoyApp/views/order/order_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'AppTheme.dart';
import 'AppThemeNotifier.dart';
import 'api/api_util.dart';

import 'models/AppData.dart';
import 'models/MyResponse.dart';

// AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
//     'android_channel', // id
//     'High Importance Notifications','k', // title
//     // 'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
// //
// // class FlutterNotificationView {
// //   void showNotification(String title, String body) {
// //     flutterLocalNotificationsPlugin.show(
// //         0,
// //         title,
// //         body,
// //         NotificationDetails(
// //             android: AndroidNotificationDetails(androidChannel.id, androidChannel.name, androidChannel.description,
// //
// //
// //         importance: Importance.max,
// //         color: Colors.blue,
// //         playSound: true,
// //         icon: '@mipmap/ic_launcher')));
// //   }
//
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print(
//       'A bg message just showed up :  ${message.messageId} ${message.notification!.title}');
//
//   if(message.data!=null&&message.data.isNotEmpty){
//     NotificationModel response=NotificationModel.fromJson(message.data);
//     flutterLocalNotificationsPlugin.show(message.hashCode, response.title['en'], response.body['en'], NotificationDetails(
//         android: AndroidNotificationDetails(
//             androidChannel.id,androidChannel.name,androidChannel.description,color:primaryColor,playSound: true,
//             enableVibration: true
//         )
//     ));
//   }
//
// }

// FlutterNotificationView() {
//   _setupAlert();
// }
//
// void _setupAlert() async {
//   await FirebaseMessaging.instance
//       .setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }
String? token;
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
  SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
   token = storage.read('tokenBoy')??null;
print('my ${storage.read('tokenBoy')}token ==>$token');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {

    runApp(ChangeNotifierProvider<AppThemeNotifier>(
      create: (context) => AppThemeNotifier(),
      child: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // void initState() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification notification = message.notification!;
  //     AndroidNotification android = message.notification!.android!;
  //     if (notification != null && android != null) {
  //       FlutterNotificationView()
  //           .showNotification(notification.title!, notification.body!);
  //     }
  //   });
  //   super.initState();
  // }
  // initFCM() async {
  //   PushNotificationsManager pushNotificationsManager =
  //   PushNotificationsManager();
  //   await pushNotificationsManager.init();
  //   // FirebaseMessaging.onBackgroundMessage(
  //   //     firebaseMessagingBackgroundHandler);
  // }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   initFCM();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return Sizer(builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            locale: Locale('ar'),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: MyHomePage());
      },
    );}
    ); }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeData? themeData;
  AuthControllerr controller=Get.put(AuthControllerr());

  @override
  void initState() {
    super.initState();
    getAppData();
   // initFCM();
  }

  getAppData() async {

    MyResponse<AppData> myResponse = await AppDataController.getAppData();

    if(myResponse.data!=null) {
      if (myResponse.data!.deliveryBoy != null) {
        print(myResponse.data!.deliveryBoy!.mobile );
        controller.saveUserFromDeliveryBoy(myResponse.data!.deliveryBoy!);
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
    AuthControllerr controller=Get.put(AuthControllerr());
    MySize().init(context);
    themeData = Theme.of(context);
    return FutureBuilder<AuthType>(
        future: controller.userAuthType(),
        builder: (context, AsyncSnapshot<AuthType> snapshot) {
          print('token ===>$token');
          if (snapshot.hasData) {
            if (snapshot.data == AuthType.VERIFIED||token!=null||token?.isNotEmpty==true) {
              return HomeScreen();
            } else if (snapshot.data == AuthType.LOGIN||token!=null||token?.isNotEmpty==true) {
              return HomeScreen();
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
