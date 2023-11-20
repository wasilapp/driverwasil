import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../cayegory_screen.dart';
import 'my_items_model.dart';
class MyItem extends GetxController{
  var mySubcategoryShops = [].obs;

  Future<void> getMyItemShop() async {
    mySubcategoryShops.clear();
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var token=prefs.getString('token');

    var url = Uri.parse(
        "https://news.wasiljo.com/public/api/v1/delivery-boy/mySubCategories");
    var response= await http.get(url, headers: {
      'Authorization': 'Bearer $token'});
    if((response.statusCode>=200&& response.statusCode<300)){
      if(response.body.isEmpty){

        return ;
      }

      print(response.body);
      List listShop=json.decode(response.body)['data']['subCategories'];
      print(json.decode(response.body)['data']['subCategories']);
      log(listShop.length.toString());log("***************************jjjjjjjjjjjjjjjjjjjj**************************************");
      for(int i=0;i<listShop.length;i++){
        print('l');

          mySubcategoryShops.add(MySubCategories.fromJson(listShop[i]));

        // shops.add(Shops.fromJson(listShopCategory[i]));
        print(' myyyyyyyyysubcategoryShops$mySubcategoryShops');
        print(' my subcategoryShops${listShop.length}');
      }
      return;
    }



  }
  Future<void> removeItem(id) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var token=prefs.getString('token');

    var headers = {
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('POST', Uri.parse('https://news.wasiljo.com/public/api/v1/delivery-boy/subcategories/remove/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      getMyItemShop();
      Get.off(CategoryScreen());
    }
    else {
      print(response.reasonPhrase);
    }




  }
}