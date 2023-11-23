import 'dart:convert';
import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:DeliveryBoyApp/models/app_user_models.dart' as appUser;
import 'package:DeliveryBoyApp/services/network/http/endPoint.dart';
import 'package:DeliveryBoyApp/services/network/http/httpHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:DeliveryBoyApp/AppTheme.dart';
import 'package:DeliveryBoyApp/models/DeliveryBoy.dart';
import 'package:DeliveryBoyApp/services/Network.dart';
import 'package:DeliveryBoyApp/services/PushNotificationsManager.dart';
import 'package:DeliveryBoyApp/utils/InternetUtils.dart';
import 'package:DeliveryBoyApp/views/order/order_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:DeliveryBoyApp/models/deliveryModel.dart';
import 'package:DeliveryBoyApp/utils/ui/prgress_hud.dart';
import 'login/LoginScreen.dart';

enum AuthType { VERIFIED, LOGIN, NOT_FOUND }

class AuthControllerr extends GetxController {
  String loginUrl =
      'https://admin.wasiljo.com/public/api/v1/delivery-boy/login?lang=ar';
  @override
  void onInit() async {
    if (token != null && token!.isNotEmpty) {
      await getData(pathUrl: ApiPath.deliveryBoyData, token: token)
          .then((value) {
        print(value);
        if (value['status'] == true) {
          appUser.appUserData = appUser.AppUserData.fromJson(value['data']);
        }
        update();
      }).catchError((error) {
        print(error);
      });
    } else {
      return null;
    }
    super.onInit();
  }

  var erroeMsg = [].obs;
  var erroeText = ''.obs;
  TextEditingController passwordTFController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool showPassword = false.obs;
  RxString countryCode = "962".obs;
  /*-----------------   Log In     ----------------------*/
  DeliveryBoyModel2? boysDeliveryData;

  dynamic loginUser(String mobile, String password) async {
    ProgressHud.shared.startLoading(Get.context);
    //Get FCM
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
    String? fcmToken = await pushNotificationsManager.getToken();

    log("mobile: " + mobile);
    log("password: " + password);
    //Body data
    Map data = {
      'mobile': mobile,
      'password': password,
    };

    //Encode
    String body = json.encode(data);

    try {
      var response = await http.post(
        Uri.parse(loginUrl),
        headers: ApiUtil.getHeader(requestType: RequestType.Post),
        body: body,
      );
      ProgressHud.shared.stopLoading();
      if (response.statusCode == 200) {
        appUser.appUserData =
            appUser.AppUserData.fromJson(json.decode(response.body));
        Get.log('response.body ${appUser.appUserData.toJson()}');
        erroeText.value = '';
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        await saveDeliveryBoyData(appUser.appUserData);

        var token = appUser.appUserData.data!.token!;
        await sharedPreferences.setString('token', token);

        erroeText.value = '';
        Get.offAll(() => HomeScreen());
        print('return');
        return;
        // myResponse.success = true;
      } else {
        Get.log(json.decode(response.body)['error']);
        erroeText.value = json.decode(response.body)['error'];
        Get.log(erroeText.value);
      }
    } catch (e) {
      print('e');
      print(e);
    }
  }

  //todo save data to firebase

  Future<void> saveDeliveryBoyData(appUser.AppUserData data) async {
    try {
      // Get the current user (assuming you are using Firebase Authentication)
      User? user = FirebaseAuth.instance.currentUser;

      // Get a reference to the Firestore collection for delivery boys
      CollectionReference deliveryBoys =
          FirebaseFirestore.instance.collection('deliveryBoys');

      // Add the delivery boy data to Firestore
      await deliveryBoys.doc(data.data?.deliveryBoy?.id.toString()).set({
        'id': data.data?.deliveryBoy?.id,
        'name': data.data?.deliveryBoy?.name.toString(),
        'latitude': data.data?.deliveryBoy?.latitude,
        'longitude': data.data?.deliveryBoy?.longitude,
        'email': '${data.data?.deliveryBoy?.email}',
        "is_free": data.data?.deliveryBoy?.isFree,
        "is_offline": data.data?.deliveryBoy?.isOffline,
        "is_active": data.data?.deliveryBoy?.isActive,
        "avatar_url": "${data.data?.deliveryBoy?.avatarUrl}",
        "category_id": data.data?.deliveryBoy?.categoryId,
        "shop_id": data.data?.deliveryBoy?.shopId,
        "is_verified": 1,
        "driving_license": data.data?.deliveryBoy?.drivingLicense,
        "is_approval": data.data?.deliveryBoy?.isApproval,
        "distance": data.data?.deliveryBoy?.distance,
        "total_capacity": data.data?.deliveryBoy?.totalCapacity,
        "total_quantity": data.data?.deliveryBoy?.totalQuantity,
        "available_quantity": data.data?.deliveryBoy?.availableQuantity,
      }).then((value) {
        print('Delivery boy data saved to Firestore successfully');
      }).catchError((e) {
        print('Error saving delivery boy data: $e');
      });

      print('Delivery boy data saved to Firestore successfully.');
    } catch (e) {
      print('Error saving delivery boy data: $e');
    }
  }

  /*-----------------  update profile    ----------------------*/

  dynamic updateUser(
      {String? mobile,
      String? password,
      String? nameEn,
      String? nameAr,
      String? distance}) async {
    print('kk');

    String? token = await getApiToken();
    ProgressHud.shared.startLoading(Get.context);
    //Get FCM
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
    String? fcmToken = await pushNotificationsManager.getToken();

    String updateUrl =
        'https://admin.wasiljo.com/public/api/v1/delivery-boy/update_profile';

    //Body data
    Map data = {
      'mobile': mobile,
      'password': password,
      distance: distance,
      'name': nameEn,
    };
    log("mobile: " + distance!);
    //Encode
    String body = json.encode(data);
    log("mobile: " + token!);
    // //Check Internet
    // bool isConnected = await InternetUtils.checkConnection();
    // if (!isConnected) {
    //   return MyResponse.makeInternetConnectionError();
    // }

    try {
      var response = await http.put(Uri.parse(updateUrl),
          headers: ApiUtil.getHeader(
              requestType: RequestType.PostWithAuth, token: token),
          body: body);
      ProgressHud.shared.stopLoading();
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('return');
        erroeText.value = '';
        print(response.body);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> user = data['data']['deliveryBoy'];
        print(user);

//
//         String token = data['data']['token'];
//         print(token);
//         await saveUser(user);
//         await sharedPreferences.setString('token', token);
//         erroeText.value='';
//
        print('return ===============');

        Get.snackbar('update profile', 'save change',
            backgroundColor: primaryColor);

        return;
        // myResponse.success = true;
      } else {
        print(json.decode(response.body)['error']);
        erroeText.value = json.decode(response.body)['error'];
        print(erroeText.value);
      }
    } catch (e) {
      print('e');
      print(e);
    }
  }

  //--------------------- Check Mobile Availability ---------------------------------------------//
  Future<MyResponse> mobileVerified(String? mobileNumber) async {
    //Get Token
    String? token = await getApiToken();

    //URL
    String url = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_MOBILE_VERIFIED;

    //Body Data
    Map data = {'mobile': mobileNumber};

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    //Response
    try {
      NetworkResponse response = await Network.post(url,
          headers: ApiUtil.getHeader(
              requestType: RequestType.PostWithAuth, token: token),
          body: body);

      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body!);
        Map<String, dynamic> user = data['delivery_boy'];

        await saveUser(
          user,
        );

        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- Mobile Verified ---------------------------------------------//
  Future<MyResponse> verifyMobileNumber(String mobileNumber) async {
    //Get Token
    String? token = await getApiToken();

    //URL
    String url = ApiUtil.MAIN_API_URL + ApiUtil.MOBILE_NUMBER_VERIFY;

    //Body Data
    Map data = {'mobile': mobileNumber};

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    //Response
    try {
      NetworkResponse response = await Network.post(url,
          headers: ApiUtil.getHeader(
              requestType: RequestType.PostWithAuth, token: token),
          body: body);

      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError();
    }
  }

  /*-----------------   Register     ----------------------*/

  dynamic registerUser(
      {required String nameEnglish,
      required String nameArabic,
      required String agencyEnglish,
      required String agencyArabic,
      required String email,
      required String password,
      mobile,
      categoryId,
      shopId,
      File? drivingLicense,
      File? profilePic,
      File? car,
      carNum}) async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://admin.wasiljo.com/public/api/v1/delivery-boy/register?lang=ar'));

    request.fields.addAll({
      'name[en]': nameArabic,
      'is_offline': '1',
      'name[ar]': nameArabic,
      'mobile': mobile,
      'password': password,
      'category_id': categoryId.toString(),
      'car_number': carNum,
      'email': email,
      'shop_id': shopId.toString(),
      'agency_name[en]': agencyArabic,
      'agency_name[ar]': agencyArabic
    });

    request.files.add(
        await http.MultipartFile.fromPath('car_license', drivingLicense!.path));
    request.files
        .add(await http.MultipartFile.fromPath('avatar_url', profilePic!.path));
    car == null
        ? ''
        : request.files.add(
            await http.MultipartFile.fromPath('driving_license', car!.path));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      erroeMsg.value.clear();
      print(await response.stream.bytesToString());
      Get.offAll(LoginScreen());
    } else {
      // If the response status code is not 200, print the error messages
      String responseBody = await response.stream.bytesToString();
      print(responseBody);

      try {
        // Parse the response body as JSON
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        if (jsonResponse.containsKey('error')) {
          // If the 'error' key exists, print the error messages
          erroeMsg.value = List<String>.from(jsonResponse['error']);
          print('Error messages: $erroeMsg.value');
        }
      } catch (e) {
        // Handle JSON parsing errors
        print('Error parsing JSON: $e');
      }
    }

//     ProgressHud.shared.startLoading(Get.context);
//     print(mobile); //Get FCM
//     // PushNotificationsManager pushNotificationsManager =
//     // PushNotificationsManager();
//     // await pushNotificationsManager.init();
//     // String? fcmToken = await pushNotificationsManager.getToken();
//
//     // log("device token is : ${fcmToken.toString()}");
//
//     String registerUrl =
//         'https://admin.wasiljo.com/public/api/v1/delivery-boy/register?lang=ar';
//
//     final dio = Dio();
//
//     // print('fcmToken.toString()${fcmToken.toString()}');
//     // Create a new FormData object
//     final formData = FormData();
// if(categoryId==2){
//   formData.fields.addAll([
//     MapEntry('name[en]', nameArabic),
//     MapEntry('name[ar]', nameEnglish),
//     // MapEntry('fcm_token', fcmToken.toString()),
//     MapEntry('email', email),
//     MapEntry('password', password),
//     MapEntry('mobile', mobile),
//     MapEntry('category_id', categoryId.toString()),
//     MapEntry('agency_name[en]', agencyEnglish ?? ''),
//     MapEntry('agency_name[ar]', agencyArabic),
//
//     MapEntry('car_number', carNum),
//   ]);
// }
// else{
//   formData.fields.addAll([
//     MapEntry('name[en]', nameArabic),
//     MapEntry('name[ar]', nameEnglish),
//     // MapEntry('fcm_token', fcmToken.toString()),
//     MapEntry('email', email),
//     MapEntry('password', password),
//     MapEntry('mobile', mobile),
//     MapEntry('category_id', categoryId.toString()),
//     MapEntry('shop_id', '3'),
//
//     MapEntry('car_number', carNum),
//   ]);
// }
//     // Add text data to the form data
//     // formData.fields.addAll([
//     //   MapEntry('name[en]', nameArabic),
//     //   MapEntry('name[ar]', nameEnglish),
//     //   // MapEntry('fcm_token', fcmToken.toString()),
//     //   MapEntry('email', email),
//     //   MapEntry('password', password),
//     //   MapEntry('mobile', mobile),
//     //   MapEntry('category_id', categoryId.toString()),
//     //   MapEntry('agency_name[en]', agencyEnglish ?? ''),
//     //   categoryId == '2'
//     //       ? MapEntry('agency_name[ar]', agencyArabic)
//     //       : MapEntry('shop_id', '3'),
//     //   MapEntry('car_number', carNum),
//     // ]);
//
//     // Add file data to the form data
//
//     if (profilePic != null) {
//       formData.files.addAll([
//         MapEntry(
//           'avatar_url',
//           await MultipartFile.fromFile(
//             profilePic.path,
//             filename: profilePic.path.split('/').last,
//           ),
//         ),
//       ]);
//     }
//
//     if (drivingLicense != null) {
//       formData.files.addAll([
//         MapEntry(
//           'driving_license',
//           await MultipartFile.fromFile(
//             drivingLicense.path,
//             filename: drivingLicense.path.split('/').last,
//           ),
//         ),
//       ]);
//     }
//
//     final headers = {
//       'Content-Type': 'application/json',
//       "Accept": "application/json",
//     };
//
//     log("3");
//
//     //Encode
//     // String body = json.encode(formData);
//
//     //Check Internet
//     bool isConnected = await InternetUtils.checkConnection();
//     if (!isConnected) {
//       return MyResponse.makeInternetConnectionError();
//     }
//
//     try {
//       ProgressHud.shared.stopLoading();
//
//       final response = await dio.post(
//         registerUrl,
//         data: formData,
//         options: Options(headers: headers),
//       );
//
//       if (response.statusCode == 200) {
//         print('yes');
//         SharedPreferences sharedPreferences =
//             await SharedPreferences.getInstance();
//
//         Map<String, dynamic> data = response.data;
//         print(response.data['message']);
//         print('**********************************');
//         // print(response.data['data']);
//         // print('**********************************');
//         //
//         // print(response.data['data']['deliveryBoy']);
//         print('**********************************');
//
//         // Map<String, dynamic> user = data['data']['deliveryBoy'];
//         print('**********************************');
//
//         // String token = data['data']['token'];
//         print('**********************************');
//
// // await saveUser(user,data['type'].toString());
//         await sharedPreferences.setString('token', data['token']);
//
//         Get.to(LoginScreen());
//         Get.snackbar(
//           Translator.translate("success_register"),
//           Translator.translate("success_register"),
//         );
//       } else {
//         print('else');
//       }
//     } catch (e) {
//       if (e is DioError) {
//         Map<String, dynamic> data = json.decode(e.response.toString());
//         log('data' + data.toString());
//
//         log("Error:" + e.response.toString());
//         log('hhhhhhhh');
//         log(e.toString());
//
//         if (e.response != null) {
//           // Print only the error message from the API response
//           final responseData = e.response!.data;
//           if (responseData is Map<String, dynamic> &&
//               responseData.containsKey('message')) {
//             print("Error during registration: ${responseData['message']}");
//           } else {
//             erroeMsg.value = List<String>.from(responseData['error']);
//
//             print("An error occurred: ${responseData['error']}");
//
//             print("An error occurred: ${responseData['error']}");
//           }
//         } else {
//           // If there's no response, print a generic error message
//           print("An error occurred: ${e.message}");
//         }
//       } else {
//         // Handle other exceptions, if any
//         print("Unexpected error: $e");
//       }
//     }
  }

  //     on DioError catch (e) {
  //
  //     MyResponse myResponse = MyResponse(422);
  //     Map<String, dynamic> data = json.decode(e.response.toString());
  //     log('data'+data.toString());
  //     log('data'+e.response!.data['error']);
  //     myResponse.success = false;
  //     myResponse.setError(data);
  //
  //     log("Error:" +e.response.toString());
  //     log('hhhhhhhh');
  //     log(e.toString());
  //     return myResponse;
  //     //  return MyResponse.makeServerProblemError();
  //   }
  // }

  /*-----------------   Forgot Password     ----------------------*/

  forgotPassword(String email, password) async {
    String url = ApiUtil.MAIN_API_URL + ApiUtil.FORGOT_PASSWORD;

    //Body date
    Map data = {'mobile': email, 'password': password};

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.post(url,
          headers: ApiUtil.getHeader(requestType: RequestType.Post),
          body: body);

      log(response.body.toString());

      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }

      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError();
    }
  }

  /*-----------------   Log Out    ----------------------*/

  Future<bool> logoutUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove('id');
    await sharedPreferences.remove('name');
    await sharedPreferences.remove('email');
    await sharedPreferences.remove('avatar_url');
    await sharedPreferences.remove('is_offline');
    await sharedPreferences.remove('mobile');
    await sharedPreferences.remove('email');
    await sharedPreferences.remove('type');
    await sharedPreferences.remove('token');
    //Remove FCM

    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.removeFCM();

    return true;
  }

  /*-----------------   Save user in cache   ----------------------*/

  saveUser(Map<String, dynamic> user) async {
    await saveUserFromDeliveryBoy(DeliveryBoyModel.fromJson(user));
  }

  saveUserFromDeliveryBoy(DeliveryBoyModel deliveryBoy) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('id', deliveryBoy.id!);
    await sharedPreferences.setInt('categoryId', deliveryBoy.category!.id!);
    await sharedPreferences.setString(
        'nameEn', deliveryBoy.name!.en.toString());
    await sharedPreferences.setString(
        'nameAr', deliveryBoy.name!.ar.toString());
    await sharedPreferences.setString('email', deliveryBoy.email!);
    await sharedPreferences.setString('avatar_url', deliveryBoy.avatarUrl!);
    await sharedPreferences.setString(
        'typeEn', deliveryBoy.category!.title!.en.toString().toString());
    await sharedPreferences.setString(
        'agencyName', deliveryBoy.agencyName.toString());
    await sharedPreferences.setString(
        'carNumber', deliveryBoy.carNumber.toString());
    await sharedPreferences.setString(
        'typeAr', deliveryBoy.category!.title!.en.toString().toString());

    await sharedPreferences.setInt('rating', deliveryBoy.rating!);
    await sharedPreferences.setInt('total_rating', deliveryBoy.totalRating!);

    await sharedPreferences.setInt(
        'shop_id', deliveryBoy.shopId == null ? 0 : deliveryBoy.shopId!);

    await sharedPreferences.setBool(
        'is_free', TextUtils.parseBool(deliveryBoy.isFree!));

    await sharedPreferences.setBool(
        'is_offline', TextUtils.parseBool(deliveryBoy.isOffline!));

    await sharedPreferences.setString('mobile', deliveryBoy.mobile!);
    // await sharedPreferences.setBool(
    //     'mobile_verified', deliveryBoy.mobileVerified!);
  }

  /*-----------------   Get user from cache     ----------------------*/

  Future<DeliveryBoyModel> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    log(sharedPreferences.getString('email').toString());
    int? id = sharedPreferences.getInt('id');
    int? categoryId = sharedPreferences.getInt('categoryId');
    String? nameEn = sharedPreferences.getString('nameEn');
    String? nameAr = sharedPreferences.getString('nameAr');
    String? agencyName = sharedPreferences.getString('agencyName');
    String? email = sharedPreferences.getString('email');
    String? token = sharedPreferences.getString('token');
    int? shopId = sharedPreferences.getInt('shop_id');
    String? carNumber = sharedPreferences.getString('carNumber');
    String? avatarUrl = sharedPreferences.getString('avatar_url');
    String? type = sharedPreferences.getString('type');
    String? mobile = sharedPreferences.getString('mobile');
    bool? isOffline = sharedPreferences.getBool('is_offline');
    bool? isFree = sharedPreferences.getBool('is_free');
    bool mobileVerified = sharedPreferences.getBool('mobile_verified') ?? false;

    return DeliveryBoyModel(
      id: id,
      mobile: mobile,
      email: email,
      category: Category(id: categoryId),
      name: Name(ar: nameAr, en: nameEn),
      shopId: shopId,
      categoryId: categoryId,
      agencyName: agencyName,
      carNumber: carNumber,
    );
  }

  /*-----------------   Update user     ----------------------*/

  //  Future<MyResponse> updateUser(
  // {
  //     String? mobile, String? password, File? imageFile,String ?nameEn,String? nameAr,String ?distance}) async {
  //
  //    String? token = await getApiToken();
  //   var registerUrl =Uri.parse('https://admin.wasiljo.com/public/api/v1/delivery-boy/register');
  //   Map data = {};
  //   if (mobile!.isNotEmpty) data['mobile'] = mobile;
  //   if (mobile.isNotEmpty) data['distance'] = distance;
  //   if (mobile.isNotEmpty) data['name'] = mobile;
  //
  //   if (password!.isNotEmpty) data['password'] = password;
  //
  //   if (imageFile != null) {
  //     final bytes = imageFile.readAsBytesSync();
  //     String img64 = base64Encode(bytes);
  //     data['avatar_image'] = img64;
  //   }
  //
  //   //Encode
  //   String body = json.encode(data);
  //
  //   //Check Internet
  //   bool isConnected = await InternetUtils.checkConnection();
  //   if (!isConnected) {
  //     return MyResponse.makeInternetConnectionError();
  //   }
  //
  //   try {
  //     var response = await http.put(
  //       registerUrl,
  //       headers: ApiUtil.getHeader(
  //           requestType: RequestType.PostWithAuth, token: token),
  //       body: body,
  //     );
  //
  //     MyResponse myResponse = MyResponse(response.statusCode);
  //     if (response.statusCode == 200) {
  //       await saveUser(json.decode(response.body!)['data']['deliveryBoy'],);
  //       myResponse.success = true;
  //     } else {
  //       Map<String, dynamic> data = json.decode(response.body!);
  //
  //       myResponse.success = false;
  //       myResponse.setErrorForRegister(data);
  //     }
  //
  //     return myResponse;
  //   } catch (e) {
  //     return MyResponse.makeServerProblemError();
  //   }
  // }

  /*-----------------   Check user login or not     ----------------------*/

  Future<AuthType> userAuthType() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? token = sharedPreferences.getString("token");
      bool mobileVerified =
          sharedPreferences.getBool('mobile_verified') ?? false;
      // String? token = sharedPreferences.getString('token');
      if (token == null) {
        log('message$token');
        return AuthType.NOT_FOUND;
      } else if (token.isNotEmpty) {
        log('message$token');
        log('mobileVerified$mobileVerified');

        return AuthType.VERIFIED;
      } else {
        return AuthType.NOT_FOUND;
      }
      // return AuthType.VERIFIED;
    } catch (e) {
      log(e.toString());
      return AuthType.NOT_FOUND;
    }
  }

  /*-----------------   Get user login token     ----------------------*/

  Future<String?> getApiToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token");
  }

  /*-----------------   Change status (online/offline)     ----------------------*/

  Future<MyResponse> changeStatus(bool status) async {
    String? token = await getApiToken();
    String registerUrl = ApiUtil.MAIN_API_URL + ApiUtil.CHANGE_STATUS;

    //Body date
    Map data = {
      'is_offline': TextUtils.parseBool(status),
    };

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<DeliveryBoy>();
    }

    try {
      NetworkResponse response = await Network.post(registerUrl,
          headers: ApiUtil.getHeader(
              requestType: RequestType.PostWithAuth, token: token),
          body: body);

      MyResponse myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        await saveUser(
          json.decode(response.body!)['delivery_boy'],
        );
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError();
    }
  }

  Widget notice(ThemeData themeData) {
    return Container(
      margin: Spacing.fromLTRB(24, 36, 24, 24),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "Note: ",
              style: AppTheme.getTextStyle(themeData.textTheme.titleSmall,
                  color: themeData.colorScheme.primary, fontWeight: 600)),
          TextSpan(
              text:
                  "After testing please logout, because there is many user testing with same IDs so it can be possible that you can get unnecessary notifications",
              style: AppTheme.getTextStyle(themeData.textTheme.bodyMedium,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 500,
                  letterSpacing: 0)),
        ]),
      ),
    );
  }
}
