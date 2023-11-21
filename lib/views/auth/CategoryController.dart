// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:DeliveryBoyApp/api/api_util.dart';
// import 'package:DeliveryBoyApp/controllers/AuthController.dart';
// import 'package:DeliveryBoyApp/models/MyResponse.dart';
// import 'package:DeliveryBoyApp/services/Network.dart';
// import 'package:DeliveryBoyApp/utils/InternetUtils.dart';
//
// import 'Categories.dart';
//
//
// class CategoryController {
//
//   //------------------------ Get all categories -----------------------------------------//
//   static Future<MyResponse<List<Category>>> getAllCategory() async {
//     print("category sttart");
//       String CATEGORIES = "categories/";
//
//
//     //Getting User Api Token
//     String? token = await AuthController.getApiToken();
//     String url = "https://wasiljo.com/public/api/v1/user/" + CATEGORIES;
//     Map<String, String> headers =
//         ApiUtil.getHeader(requestType: RequestType.GetWithAuth,);
//
//     //Check Internet
//     bool isConnected = await InternetUtils.checkConnection();
//     if (!isConnected) {
//       return MyResponse.makeInternetConnectionError<List<Category>>();
//     }
//
//     try {
//       NetworkResponse response = await Network.get(url, headers: headers);
//       MyResponse<List<Category>> myResponse = MyResponse(response.statusCode);
//       log(response.body.toString());
//       if (response.statusCode == 200) {
//         log("category done");
//
//         List<Category> list =
//             categoryFromMap(response.body!);
//           log("category done 2");
//         myResponse.success = true;
//         myResponse.data = list;
//
//       } else {
//         print("category error");
//         myResponse.setError(json.decode(response.body!));
//       }
//
//       return myResponse;
//     } catch (e) {
//       //If any server error...
//       return MyResponse.makeServerProblemError<List<Category>>();
//     }
//   }
//
//
//   //------------------------ Get category SubCategory -----------------------------------------//
//
//
//   //------------------------ Get category shop -----------------------------------------//
//
//   static Future<MyResponse<List<Shop>>> getCategoryShops(int categoryId) async {
//       String CATEGORIES = "categories/";
// const String SHOPS = "shops/";
//     //Getting User Api Token
//     String? token = await AuthController.getApiToken();
//     String url = ApiUtil.MAIN_API_URL +
//         CATEGORIES +
//         categoryId.toString() +
//         "/" +
//       SHOPS;
//     Map<String, String> headers =
//     ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);
//
//     //Check Internet
//     bool isConnected = await InternetUtils.checkConnection();
//     if (!isConnected) {
//       return MyResponse.makeInternetConnectionError<List<Shop>>();
//     }
//
//     try {
//       NetworkResponse response = await Network.get(url, headers: headers);
//       MyResponse<List<Shop>> myResponse = MyResponse(response.statusCode);
//       print("shop sta");
//       if (response.statusCode == 200) {
//         print("shop done");
//         myResponse.success = true;
//         print(response.body);
//         myResponse.data = shopsFromMap(response.body!);
//
//       } else {
//         print("shop error");
//         myResponse.setError(json.decode(response.body!));
//       }
//
//       return myResponse;
//     } catch (e) {
//       print(e.toString());
//       //If any server error...
//       return MyResponse.makeServerProblemError<List<Shop>>();
//     }
//   }
//
//
//
//
// }
import 'dart:convert';
import 'dart:developer';
import 'package:DeliveryBoyApp/controllers/general_status_model.dart';
import 'package:DeliveryBoyApp/views/auth/shop_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/controllers/AuthController.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/services/Network.dart';
import 'package:DeliveryBoyApp/utils/InternetUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../category/add_item/item_shop_mofel.dart';
import 'Categories.dart';

class CategoryController extends GetxController {
  var category = [].obs;
  var shops = [].obs;
  var subcategoryShops = [].obs;
  late var statusModel = GeneralStatusModel().obs;
  @override
  void onInit() {
    super.onInit();
    getCategory();
    getShop();
    // getItemShop();
  }

  //------------------------ Get all categories -----------------------------------------//
  Future<void> getCategory() async {
    statusModel.value.updateStatus(GeneralStatus.waiting);
    print('object');
    var url = Uri.parse(
        "https://admin.wasiljo.com/public/api/v1/delivery-boy/categories");

    var response = await http.get(url);
    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      if (response.body.isEmpty) {

        statusModel.value.updateStatus(GeneralStatus.error);
        statusModel.value.updateError('some thing error');
        return;
      }
      statusModel.value.updateStatus(GeneralStatus.success);

      List listCategory = json.decode(response.body)['data']['categories'];

      for (int i = 0; i < listCategory.length; i++) {
        category.add(Categories.fromJson(listCategory[i]));
      }
      print(response.body);
      return;
    }
    statusModel.value.updateStatus(GeneralStatus.error);
    statusModel.value.updateError('some thing error');
  }

  //------------------------ Get all categories -----------------------------------------//
  Future<void> getShop() async {
    statusModel.value.updateStatus(GeneralStatus.waiting);

    var url = Uri.parse(
        "https://admin.wasiljo.com/public/api/v1/delivery-boy/shops");
    var response= await http.get(url);
    if((response.statusCode>=200&& response.statusCode<300)){
      if(response.body.isEmpty){

        statusModel.value.updateStatus(GeneralStatus.error);
        statusModel.value.updateError('some thing error');
        return;
      }
      statusModel.value.updateStatus(GeneralStatus.success);
      print(response.body);
      List listShop = json.decode(response.body)['data']['shops'];

      for (int i = 0; i < listShop.length; i++) {
        shops.add(ShopsModel.fromJson(listShop[i]));
        // shops.add(Shops.fromJson(listShopCategory[i]));
        print('shops$shops');
        print('shops${listShop.length}');
      }
      return;
    }
    statusModel.value.updateStatus(GeneralStatus.error);
    statusModel.value.updateError('some thing error');
  }

  Future<void> getItemShop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    statusModel.value.updateStatus(GeneralStatus.waiting);
    var url = Uri.parse(
        "https://admin.wasiljo.com/public/api/v1/delivery-boy/shop-subcategories");

    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      if (response.body.isEmpty) {

        statusModel.value.updateStatus(GeneralStatus.error);
        statusModel.value.updateError('some thing error');
        return;
      }
      statusModel.value.updateStatus(GeneralStatus.success);
      print(response.body);
      List listShop =
          json.decode(response.body)['data']['shop'][0]['sub_category'];

      for (int i = 0; i < listShop.length; i++) {
        subcategoryShops.add(SubCategory.fromJson(listShop[i]));
        // shops.add(Shops.fromJson(listShopCategory[i]));
        print('subcategoryShops$subcategoryShops');
        print('subcategoryShops${listShop.length}');
      }
      return;
    }
    statusModel.value.updateStatus(GeneralStatus.error);
    statusModel.value.updateError('some thing error');
  }

  get isWaiting => statusModel.value.status.value == GeneralStatus.waiting;
  get isError => statusModel.value.status.value == GeneralStatus.error;
  get isSuccess => statusModel.value.status.value == GeneralStatus.success;
}
