import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:DeliveryBoyApp/views/profile_view/show_driver.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryBoyShowProfile extends GetxController {
  DeliveryBoyShow deliveryBoy = DeliveryBoyShow();

  getDriver() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token'};
    var response = await http.get(
      Uri.parse(
          'https://admin.wasiljo.com/public/api/v1/delivery-boy/get_transaction_order'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(await response.body);
      final jsonData = json.decode(response.body);
      deliveryBoy = DeliveryBoyShow.fromJson(jsonData['data']['deliveryBoy']);
      print('ddd$deliveryBoy');
    } else {
      print(response.body);
    }
  }

  Future<void> updateStatus(int status) async {
    print("""""$status""");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bearerToken = prefs.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    var request = http.Request(
        'PUT',
        Uri.parse(
            'https://admin.wasiljo.com/public/api/v1/delivery-boy/update_profile'));

    request.body = json.encode({
      // "manager": {
      //   "name": {
      //     "en": mangerNameEnglish!.text,
      //     "ar": mangerNameArabic!.text
      //   }
      // },
      "is_offline": status,
      // "distance":distance!.text
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
