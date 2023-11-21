import 'dart:convert';

import 'package:DeliveryBoyApp/models/DeliveryBoy.dart';
import 'package:DeliveryBoyApp/utils/toast.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/general_status_model.dart';
import 'order_model.dart';

class GetOrderController extends GetxController {
  var orders = [].obs;
  var status = 'all'.obs;
  late var statusModel = GeneralStatusModel().obs;

/*الحالات الخاصة بapi جلب الطلبات
pending = 1
accepted_by_shop = 2
assign_shop_to_delivery = 3
accepted_by_driver = 4
on_the_way = 5
delivered = 6
reviewed = 7
rejected_by_shop = 8
rejected_by_driver = 9
cancelled_by_user = 10
cancelled_by_shop = 11
cancelled_by_driver = 12*/
//********************************getOrders***************************************
  AuthControllerr controller = Get.put(AuthControllerr());

  void getOrders() async {
    String? token = await controller.getApiToken();
    print(token);

    statusModel.value.updateStatus(GeneralStatus.waiting);
    var url = Uri.parse(
        'https://admin.wasiljo.com/public/api/v1/delivery-boy/orders/$status/scheduled/get');
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      print(
          '*****************************************************************************');

      if (response.body.isEmpty) {
        statusModel.value.updateStatus(GeneralStatus.error);
        statusModel.value.updateError("No Result Found");
        return;
      }
      print(response.body);
      List result = json.decode(response.body)['data']['orders'];
      print(result.length);
      orders.clear();
      for (int index = 0; index < result.length; index++) {
        orders.add(OrdersModel.fromJson(result[index]));
        print(orders);
        print(
            '*****************************************************************************');
      }
      statusModel.value.updateStatus(GeneralStatus.success);

      return;
    }
    print(response.body);
    statusModel.value.updateStatus(GeneralStatus.error);
    statusModel.value.updateError("Something went wrong");
  }
  //********************************getOrders***************************************

  void changeStatus(orderId, status) async {
    String? token = await controller.getApiToken();
    statusModel.value.updateStatus(GeneralStatus.waiting);
    print(
        'https://admin.wasiljo.com/public/api/v1/delivery-boy/order/$orderId/$status');
    var url = Uri.parse(
        'https://admin.wasiljo.com/public/api/v1/delivery-boy/order/$orderId/$status');
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.body);

    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      print(
          '*****************************************************************************');

      if (response.body.isEmpty) {
        statusModel.value.updateStatus(GeneralStatus.error);
        statusModel.value.updateError("No Result Found");
        return;
      }
      print(response.body);

      statusModel.value.updateStatus(GeneralStatus.success);

      return;
    }
    if (response.statusCode == 400) {
      print(json.decode(response.body)['error']);
      showtoast(
          text: json.decode(response.body)['error'].toString() ?? 'error',
          state: ToastStates.WARRING);
    }

    statusModel.value.updateStatus(GeneralStatus.error);
    statusModel.value.updateError("Something went wrong");
    getOrders();
  }

  get isWaiting => statusModel.value.status.value == GeneralStatus.waiting;

  get isError => statusModel.value.status.value == GeneralStatus.error;

  get isSuccess => statusModel.value.status.value == GeneralStatus.success;
  void openMap({required double latitude, required double longitude}) async {
    // Specify the latitude and longitude of the location

    // Create the map URL with the specified coordinates
    String mapUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    // Check if the URL can be launched
    if (await canLaunch(mapUrl)) {
      // Launch the URL
      await launch(mapUrl);
    } else {
      // Handle the case where the map URL cannot be launched
      print('Could not launch $mapUrl');
    }
  }

  void openPhoneDialer({required String phone}) async {
    // Specify the phone number you want to call
    String phoneNumber = '${phone}';

    // Create the phone dialer URL with the specified phone number
    String phoneUrl = 'tel:$phoneNumber';

    // Check if the URL can be launched
    if (await canLaunch(phoneUrl)) {
      // Launch the URL
      await launch(phoneUrl);
    } else {
      // Handle the case where the phone dialer URL cannot be launched
      print('Could not launch $phoneUrl');
    }
  }

  DeliveryBoyModel? deliveryBoyModel;
  showDriver() async {
    String? token = await controller.getApiToken();
    statusModel.value.updateStatus(GeneralStatus.waiting);

    var url =
        Uri.parse('https://admin.wasiljo.com/public/api/v1/delivery-boy/show');
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('==>${response.body}');
  }
}
