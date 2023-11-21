import 'package:DeliveryBoyApp/models/boyData.dart';
import 'package:DeliveryBoyApp/services/network/http/endPoint.dart';
import 'package:DeliveryBoyApp/services/network/http/httpHelper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/boyCategorylist.dart';
import '../../auth/authControllernew.dart';

class Category_Controller extends GetxController {
  AuthControllerr controller = Get.put(AuthControllerr());
  String token = '';
  gettoken() async {
    token = (await controller.getApiToken()) ?? '';
    print(token);
  }

  BoyData? boydata;
  BoySubCategory? myCategory;
  getCategoryData() async {
    if (token.isEmpty) {
      await gettoken();
    }
    print('token ==> ${token}');
    await getData(pathUrl: ApiPath.supCategory, token: token).then((value) {
      print(value);
      if (value['status']) {
        myCategory = BoySubCategory.fromJson(value);
        print(myCategory?.status);
        update();
      }
    }).catchError((error) {
      print(error);
    });
  }

  getDeliveryBoyData() async {
    if (token.isEmpty) {
      await gettoken();
    }
    print('token ==> ${token}');
    await getData(pathUrl: ApiPath.deliveryBoyData, token: token).then((value) {
      print(value);
      if (value['status']) {
        boydata = BoyData.fromJson(value['data']);
      }
      update();
    }).catchError((error) {
      print(error);
    });
  }

  deleteCategory({required String? id}) async {
    print("object");
//   await postData(pathUrl: ApiPath.removeCategory+'/${id}', body:{},header: {
//     'Authorization': 'Bearer ${token}'
//   },token: token).then((value) {
// print(value);
//   }).catchError((error){
//     print(error);
//   });

    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZmZmZjJjMmNhMDhkMDJiZjVhYjc2N2Q5MzA0YjI5OTVmNTRiYzk3YmVhODBiM2Q2YTU0ZDBjZjM0NTNiY2NjOTExYTUyOWIxOWZjYzE2YjciLCJpYXQiOjE3MDAwNDAxNTkuNjQ1MDU1LCJuYmYiOjE3MDAwNDAxNTkuNjQ1MDU4LCJleHAiOjE3MzE2NjI1NTkuNjQxMjM1LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.P6p5gaIDyB5DWLOiy3ZY8L6vuG84RRDouwz_lZuR4bEx01yBjxK3H0GYh75OTJeMT21sUzil8BeI3Y3VA270nGXD1GKH9hYbp3sWV7PpWd75lHMaOyZC7NFVXzEbdmllYOVuDbCaKPe_u0YBicPHBC2kJ1kuB9XXuFRQqg9CQcDlX-v1gjNWOXDcy31rf2JZVKauE7u4RI9wuFKsMRiax93d4PrZBdOC4wgO0oAIQTw3mAwKYLSPAyfm3ZoplY7I1wDlm0-MIEPoi_8hgsYpSyxvIXJpC3EfOtwltwotnJuzbnRGuWGn8EjzVoJh0Vwag-lPJ8nagnMdgz1kbidLPyzEJ15JFgE2UDgMQTkZFKCQ9bK5SZLxIWubllan0IudsBEBmnRkRz9YJmysr6VsKg6mQBNdG63yV4kMR_-XGJr7KHJuxMTimVkuoWx_T2fpoN_rYcHlpGYD3_LGwzANTETV00mGsq2urNtIEUtt_nkW7N7GUPgNFkaiYG767cOx2tdT9IZVcuDFP0IsNwi_b_THQBAyRxJd6ngfEG5yD7DhihLQMFvD1ZvyLDFM9usCeexAn33O2QGVUSgjncaofv7fBDmqud8dHmQTztNUDQRb00GUbbYNeyzCybBm8BbwIJ0xeCwS3Y-qWOhva5D-TY4NdRIMW55pGT5O35YScaQ'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://admin.wasiljo.com/public/api/v1/delivery-boy/subcategories/remove/${id}'));
    request.bodyFields = {};
    request.headers.addAll(headers);


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    getCategoryData();
    update();
  }

  addNewCategory(
      {required String catgId,
      required String totalamount,
      required String availableAmount}) {
    postData(pathUrl: ApiPath.supCategory, body: {
      'category_id': catgId,
      'total': totalamount,
      'available': availableAmount,
    }).then((value) {
      print(value);
    }).catchError((error) {
      print(error);
    });
  }
}
