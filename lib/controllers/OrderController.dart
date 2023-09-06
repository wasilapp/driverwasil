import 'dart:convert';
import 'dart:developer';
import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/models/AllOrdersModel.dart';

import 'package:DeliveryBoyApp/models/MyResponse.dart';

import 'package:DeliveryBoyApp/services/Network.dart';
import 'package:DeliveryBoyApp/utils/InternetUtils.dart';
import 'AuthController.dart';

import 'package:http/http.dart' as http;

class OrderController {


  /*-----------------   Get all order for currently login user  ----------------------*/
  static Future<MyResponse<AllOrders>> getAllOrder() async {

    //Get Token
    String? token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.ORDERS;
    Map<String, String> headers =
    ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<AllOrders>();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);

      log("response: ${response.body}");

      MyResponse<AllOrders> myResponse = MyResponse(response.statusCode);
      if (response.statusCode == 200) {
        myResponse.success = true;
        myResponse.data = AllOrders.fromJson(json.decode(response.body!));
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    }catch(e){

      log(e.toString());

      return MyResponse.makeServerProblemError<AllOrders>();

    }
  }

    static Future<MyResponse> acceptRefuseOrder(int? orderId,
      {int status = -1,}) async {

        log("1");
    //Get Token
    String? token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.ACCEPT_REFUSE_ORDER;
    Map<String, String> headers =
    ApiUtil.getHeader(requestType: RequestType.PostWithAuth, token: token);



     log("2");
    //Body data
    Map data = {
      "order_id":orderId.toString(),
      "status":status.toString()
    };




    log(data.toString());

   log("3");


    //Encode
    String body = json.encode(data);

       log("4");

    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError();
    }
   log("5");
    try {
      NetworkResponse response = await Network.post(
          url, headers: headers, body: body);
   log("6");

      MyResponse myResponse = MyResponse(response.statusCode);

         log("7");

      if (response.statusCode == 200) {

         log("8");
        log("successed");

        myResponse.success = true;
      } else {



         log(response.body!.toString());
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    }catch(e){
      log("error: "+e.toString());
      return MyResponse.makeServerProblemError();
    }
  }




  /*-----------------   update order    ----------------------*/
  // Order Status
  // current location in latitude and longitude

  static Future<MyResponse> updateOrder(int? orderId,
      {int status = -1, double latitude = -1, double longitude = -1,int? otp}) async {
    //Get Token
    String? token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.ORDERS + orderId.toString();
    Map<String, String> headers =
    ApiUtil.getHeader(requestType: RequestType.PostWithAuth, token: token);

    //Body data
    Map data = {};
    if (status != -1) {
      data['status'] = status;
    }
    if (latitude != -1) {
      data['latitude'] = latitude;
    }
    if (longitude != -1) {
      data['longitude'] = longitude;
    }

    if(otp!=null){
      data['otp']=otp;
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
          url, headers: headers, body: body);


      MyResponse myResponse = MyResponse(response.statusCode);

      if (response.statusCode == 200) {
        myResponse.success = true;
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    }catch(e){
      return MyResponse.makeServerProblemError();
    }
  }



}
