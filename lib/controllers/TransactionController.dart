import 'dart:convert';

import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/models/Transaction.dart';
import 'package:DeliveryBoyApp/services/Network.dart';
import 'package:DeliveryBoyApp/utils/InternetUtils.dart';

import 'AuthController.dart';

class TransactionController {


  /*-----------------   Get all time revenue for currently login user    ----------------------*/

  List<Transaction>? transactionsList;

  static Future<MyResponse<List<Transaction>>> getTransactions() async {
    //Get Token
    String? token = await AuthController.getApiToken();
    String url = ApiUtil.MAIN_API_URL + ApiUtil.Transactions;
    Map<String, String> headers =
    ApiUtil.getHeader(requestType: RequestType.GetWithAuth, token: token);
print(token);
    //Check Internet
    bool isConnected = await InternetUtils.checkConnection();
    if (!isConnected) {
      return MyResponse.makeInternetConnectionError<List<Transaction>>();
    }

    try {
      NetworkResponse response = await Network.get(url, headers: headers);
      MyResponse<List<Transaction>> myResponse = MyResponse(
          response.statusCode);
      print(response.body);
      print('===========================');

      if (true
      //response.statusCode == 200
      ) {
        print('===========================');

       // myResponse.success = true;
        myResponse.data = Transaction.getListFromJson(json.decode(response.body!));
        print('==============gggg=============');
      } else {
        Map<String, dynamic> data = json.decode(response.body!);
        myResponse.success = false;
        myResponse.setError(data);
      }
      return myResponse;
    } catch (e) {
      return MyResponse.makeServerProblemError<List<Transaction>>();
    }
  }

  static double getTotalPayToAdmin(List<Transaction> transactions){
    double totalPayToAdmin = 0;
    for(Transaction transaction in transactions){
      totalPayToAdmin+=transaction.deliveryBoyToAdmin;
    }
    return totalPayToAdmin;
  }


  static double getTotalTakeFromAdmin(List<Transaction> transactions){
    double totalGetFromAdmin = 0;
    for(Transaction transaction in transactions){
      totalGetFromAdmin+=transaction.adminToDeliveryBoy;
    }
    return totalGetFromAdmin;
  }


}