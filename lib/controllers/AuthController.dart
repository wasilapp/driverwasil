import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:DeliveryBoyApp/AppTheme.dart';
import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/models/DeliveryBoy.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/services/Network.dart';
import 'package:DeliveryBoyApp/services/PushNotificationsManager.dart';
import 'package:DeliveryBoyApp/utils/InternetUtils.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/utils/TextUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthType { VERIFIED, LOGIN, NOT_FOUND }

class AuthController {
  /*-----------------   Log In     ----------------------*/

  static Future<MyResponse> loginUser(String email, String password) async {
    //Get FCM
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
    String? fcmToken = await pushNotificationsManager.getToken();

    String loginUrl = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_LOGIN;
    log("mobile: " +email.toString());
    //Body data
    Map data = {'email': email, 'password': password, 'fcm_token': fcmToken};

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.post(loginUrl,
          headers: ApiUtil.getHeader(requestType: RequestType.Post),
          body: body);


      MyResponse myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        Map<String, dynamic> data = json.decode(response.body!);
        Map<String, dynamic> user = data['delivery_boy'];

    
        String token = data['token'];

        await saveUser(user,data['type']);
        await sharedPreferences.setString('token', token);

        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }

      return myResponse;
    }   on DioError catch (e) {

      MyResponse myResponse = MyResponse(422);
        Map<String, dynamic> data = json.decode(e.response.toString());
        log(data.toString());
        myResponse.success = false;
        myResponse.setError(data);
   
      log("Error:" +e.response.toString());
      log(e.toString());
           return myResponse;
    //  return MyResponse.makeServerProblemError();
    }
  }

  //--------------------- Check Mobile Availability ---------------------------------------------//
  static Future<MyResponse> mobileVerified(String? mobileNumber) async {
    //Get Token
    String? token = await AuthController.getApiToken();

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

        await saveUser(user,data['type']);

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
  static Future<MyResponse> verifyMobileNumber(String mobileNumber) async {
    //Get Token
    String? token = await AuthController.getApiToken();

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

  static dynamic registerUser(
      String name, String email, String password, mobile, category,shop,File? drivingLicense,File? profilePic , carNum) async {
    //Get FCM
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
    String? fcmToken = await pushNotificationsManager.getToken();


    log("device token is : ${fcmToken.toString()}");

    String registerUrl = ApiUtil.MAIN_API_URL + ApiUtil.AUTH_REGISTER;

    final dio = Dio();
    

        // Create a new FormData object
    final formData = FormData();

    // Add text data to the form data
    formData.fields.addAll([
      MapEntry('name', name),
      MapEntry('email', email),
      MapEntry('password', password),
      MapEntry('mobile', mobile),
      MapEntry('category_id', category==null? "" : category.id.toString()),
      MapEntry('shop_id', shop==null? "" : shop.id.toString()),
      MapEntry('car_number', carNum),
      MapEntry('fcm_token', fcmToken.toString()),
    ]);

        // Add file data to the form data

          if(profilePic!=null){

              formData.files.addAll([
          
            MapEntry(
              'profile_img',
              await MultipartFile.fromFile(
                profilePic.path,
                filename: profilePic.path.split('/').last,
              ),
            ),
          ]);

          }

        if(drivingLicense!=null){

        formData.files.addAll([
          
              MapEntry(
              'driving_license',
              await MultipartFile.fromFile(
                drivingLicense.path,
                filename: drivingLicense.path.split('/').last,
              ),
            ),
         ]);

    }

        final headers = {

           'Content-Type': 'application/json',
            "Accept": "application/json",

    };

    log("3");
  
   



    //Encode
   // String body = json.encode(formData);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }
 log("4");
    try {
      // NetworkResponse response = await Network.post(registerUrl,
      //     headers: ApiUtil.getHeader(requestType: RequestType.Post),
      //     body: formData);
 log("5");
           final response = await dio.post(
            "https://wasiljo.com/public/api/v1/delivery-boy/register",
            data: formData ,
              options: Options(headers: headers),
            
          );
           log("6");

          log("Error : " +response.data.toString());

      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        Map<String, dynamic> data = response.data;
        Map<String, dynamic> user = data['delivery_boy'];
        String token = data['token'];
        log(data['type'].toString());
        await saveUser(user,data['type'].toString());
        await sharedPreferences.setString('token', token);

        myResponse.success = true;
      } else {
      
        Map<String, dynamic> data = json.decode(response.data!);
        
        myResponse.success = false;
        myResponse.setError(data);
        
      }

      return myResponse;
    } on DioError catch (e) {

      MyResponse myResponse = MyResponse(422);
        Map<String, dynamic> data = json.decode(e.response.toString());
        log(data.toString());
        myResponse.success = false;
        myResponse.setError(data);

      log("Error:" +e.response.toString());
      log(e.toString());
           return myResponse;

    //  return MyResponse.makeServerProblemError();
    }
  }

  /*-----------------   Forgot Password     ----------------------*/

  static forgotPassword(String email,password) async {
    String url = ApiUtil.MAIN_API_URL + ApiUtil.FORGOT_PASSWORD;

    //Body date
    Map data = {'mobile': email,'password' : password};

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

  static Future<bool> logoutUser() async {

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

  static saveUser(Map<String, dynamic> user,String? type) async {
    await saveUserFromDeliveryBoy(DeliveryBoy.fromJson(user,type.toString()));
  }

  static saveUserFromDeliveryBoy(DeliveryBoy deliveryBoy) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('id', deliveryBoy.id!);
    await sharedPreferences.setString('name', deliveryBoy.name!);
    await sharedPreferences.setString('email', deliveryBoy.email!);
    await sharedPreferences.setString('avatar_url', deliveryBoy.avatarUrl!);
    await sharedPreferences.setString('type', deliveryBoy.type!.toString());

    await sharedPreferences.setInt('rating', deliveryBoy.rating!);
    await sharedPreferences.setInt('total_rating', deliveryBoy.totalRating!);

    await sharedPreferences.setInt('shop_id', deliveryBoy.shopId==null ? 0 :  deliveryBoy.shopId!);
    
    await sharedPreferences.setBool('is_free', deliveryBoy.isFree!);

    await sharedPreferences.setBool('is_offline', deliveryBoy.isOffline!);
  
    await sharedPreferences.setString('mobile', deliveryBoy.mobile!);
    await sharedPreferences.setBool(
        'mobile_verified', deliveryBoy.mobileVerified!);
  }

  /*-----------------   Get user from cache     ----------------------*/

  static Future<DeliveryBoy> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    log(sharedPreferences.getString('email').toString());
    int? id = sharedPreferences.getInt('id');
    String? name = sharedPreferences.getString('name');
    String? email = sharedPreferences.getString('email');
    String? token = sharedPreferences.getString('token');
     int? shopId = sharedPreferences.getInt('shop_id');
    String? avatarUrl = sharedPreferences.getString('avatar_url');
    String? type = sharedPreferences.getString('type');
    String? mobile = sharedPreferences.getString('mobile');
    bool? isOffline = sharedPreferences.getBool('is_offline');
    bool? isFree = sharedPreferences.getBool('is_free');
    bool mobileVerified = sharedPreferences.getBool('mobile_verified') ?? false;

    return DeliveryBoy(
     id,  name, email, token, avatarUrl, mobile, isOffline, mobileVerified,isFree,null,null,shopId,null,type);
  }

  /*-----------------   Update user     ----------------------*/

  static Future<MyResponse> updateUser(
      String mobile, String password, File? imageFile) async {
    //Get Token
    String? token = await AuthController.getApiToken();
    String registerUrl = ApiUtil.MAIN_API_URL + ApiUtil.UPDATE_PROFILE;

    Map data = {};
    if (mobile.isNotEmpty) data['mobile'] = mobile;

    if (password.isNotEmpty) data['password'] = password;

    if (imageFile != null) {
      final bytes = imageFile.readAsBytesSync();
      String img64 = base64Encode(bytes);
      data['avatar_image'] = img64;
    }

    //Encode
    String body = json.encode(data);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }

    try {
      NetworkResponse response = await Network.post(
        registerUrl,
        headers: ApiUtil.getHeader(
            requestType: RequestType.PostWithAuth, token: token),
        body: body,
      );

      MyResponse myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        await saveUser(json.decode(response.body!)['delivery_boy'],json.decode(response.body!)['type']);
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
       
        myResponse.success = false;
        myResponse.setErrorForRegister(data);
      }

      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError();
    }
  }

  /*-----------------   Check user login or not     ----------------------*/

  static Future<AuthType> userAuthType() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? token = sharedPreferences.getString("token");
      bool mobileVerified =
          sharedPreferences.getBool('mobile_verified') ?? false;
      if (token == null) {
        return AuthType.NOT_FOUND;
      } else if (!mobileVerified) {
        return AuthType.LOGIN;
      }
      return AuthType.VERIFIED;
    } catch (e) {}
    return AuthType.NOT_FOUND;
  }

  /*-----------------   Get user login token     ----------------------*/

  static Future<String?> getApiToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();



    return sharedPreferences.getString("token");
  }

  /*-----------------   Change status (online/offline)     ----------------------*/

  static Future<MyResponse> changeStatus(bool status) async {
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
        await saveUser(json.decode(response.body!)['delivery_boy'],json.decode(response.body!)['type']);
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

  static Widget notice(ThemeData themeData) {
    return Container(
      margin: Spacing.fromLTRB(24, 36, 24, 24),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "Note: ",
              style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
                  color: themeData.colorScheme.primary, fontWeight: 600)),
          TextSpan(
              text:
                  "After testing please logout, because there is many user testing with same IDs so it can be possible that you can get unnecessary notifications",
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 500,
                  letterSpacing: 0)),
        ]),
      ),
    );
  }
}
