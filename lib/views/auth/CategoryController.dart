import 'dart:convert';
import 'dart:developer';

import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/controllers/AuthController.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/services/Network.dart';
import 'package:DeliveryBoyApp/utils/InternetUtils.dart';

import 'Categories.dart';


class CategoryController {

  //------------------------ Get all categories -----------------------------------------//
  static Future<MyResponse<List<Category>>> getAllCategory() async {
    print("category sttart");
      String CATEGORIES = "categories/";

   
    //Getting User Api Token
    String? token = await AuthController.getApiToken();
    String url = "https://wasiljo.com/public/api/v1/user/" + CATEGORIES;
    Map<String, String> headers =
        ApiUtil.getHeader(requestType: RequestType.GetWithAuth,);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<List<Category>>();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<List<Category>> myResponse = MyResponse(response.statusCode);
      log(response.body.toString());
      if (response.statusCode == 200) {
        log("category done");
        
        List<Category> list =
            categoryFromMap(response.body!);
          log("category done 2");
        myResponse.success = true;
        myResponse.data = list;
        
      } else {
        print("category error");
        myResponse.setError(json.decode(response.body!));
      }

      return myResponse;
    } catch (e) {
      //If any server error...
      return MyResponse.makeServerProblemError<List<Category>>();
    }
  }


  //------------------------ Get category SubCategory -----------------------------------------//


  //------------------------ Get category shop -----------------------------------------//

  static Future<MyResponse<List<Shop>>> getCategoryShops(int categoryId) async {
      String CATEGORIES = "categories/";
const String SHOPS = "shops/";
    //Getting User Api Token
    String? token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL +
        CATEGORIES +
        categoryId.toString() +
        "/" +
      SHOPS;
    Map<String, String> headers =
    ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<List<Shop>>();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<List<Shop>> myResponse = MyResponse(response.statusCode);
      print("shop sta");
      if (response.statusCode == 200) {
        print("shop done");
        myResponse.success = true;
        print(response.body);
        myResponse.data = shopsFromMap(response.body!);

      } else {
        print("shop error");
        myResponse.setError(json.decode(response.body!));
      }

      return myResponse;
    } catch (e) {
      print(e.toString());
      //If any server error...
      return MyResponse.makeServerProblemError<List<Shop>>();
    }
  }




}
