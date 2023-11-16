// import 'package:DeliveryBoyApp/custom_bakage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//  AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
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
//   Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     print(
//         'A bg message just showed up :  ${message.messageId} ${message.notification!.title}');
//
// if(message.data!=null&&message.data.isNotEmpty){
//   NotificationModel respobse=NotificationModel.fromJson(message.data);
// flutterLocalNotificationsPlugin.show(message.hashCode, respobse.title['en'], respobse.body['en'], NotificationDetails(
//   android: AndroidNotificationDetails(
//     androidChannel.id,androidChannel.name,androidChannel.description,color:primaryColor,playSound: true,
//     enableVibration: true
//   )
// ));
// }
//
//   }
//
//   // FlutterNotificationView() {
//   //   _setupAlert();
//   // }
//
//   // void _setupAlert() async {
//   //   await FirebaseMessaging.instance
//   //       .setForegroundNotificationPresentationOptions(
//   //     alert: true,
//   //     badge: true,
//   //     sound: true,
//   //   );
//   // }
//
// class NotificationModel {
//   final Map<String, dynamic> title;
//   final Map<String, dynamic> body;
//   final String icon;
//   final dynamic data;
//   final String url;
//
//   NotificationModel({
//     required this.title,
//     required this.body,
//     required this.icon,
//     required this.data,
//     required this.url,
//   });
//
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       title: json['title'] ?? {},
//       body: json['body'] ?? {},
//       icon: json['icon'] ?? '',
//       data: json['data'],
//       url: json['url'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'body': body,
//       'icon': icon,
//       'data': data,
//       'url': url,
//     };
//   }
// }
