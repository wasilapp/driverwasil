import 'dart:convert';
import 'dart:developer';

import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:DeliveryBoyApp/models/boyData.dart';
import 'package:DeliveryBoyApp/views/category/widget/custom_textfaild.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_user_models.dart';
import '../../services/AppLocalizations.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/colors.dart';
import '../../utils/ui/textfeild.dart';
import '../auth/CategoryController.dart';
import 'add_item/item_shop_mofel.dart';
import 'cayegory_screen.dart';
import 'controller/CategoryController.dart';
import 'gas_model.dart';

class AddNewCategory extends StatefulWidget {
  AddNewCategory({Key? key});

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  TextEditingController totalcontoller = TextEditingController();

  TextEditingController availableController = TextEditingController();
  var subcategoryShops = [].obs;
  var subcategoryGas = [].obs;


Future<void> getItemShop() async {
  SharedPreferences prefs=await SharedPreferences.getInstance();
  var token=prefs.getString('token');

  var url = Uri.parse(
      "https://admin.wasiljo.com/public/api/v1/delivery-boy/shop-subcategories");
  var response= await http.get(url, headers: {
    'Authorization': 'Bearer $token'});
  if((response.statusCode>=200&& response.statusCode<300)){
    if(response.body.isEmpty){


      return ;}
      print(response.body);
      List listShop =
          json.decode(response.body)['data']['shop'][0]['sub_category'];
      print(json.decode(response.body)['data']['shop'][0]['sub_category']);
      log(listShop.length.toString());
      log("*****************************************************************");
      for (int i = 0; i < listShop.length; i++) {
        setState(() {
          subcategoryShops.add(SubCategory.fromJson(listShop[i]));
        });
        // shops.add(Shops.fromJson(listShopCategory[i]));
        print('subcategoryShops$subcategoryShops');
        print('subcategoryShops${listShop.length}');
      }
      return;
    }
  }


Future<void> getItemGas() async {
  SharedPreferences prefs=await SharedPreferences.getInstance();
  var token=prefs.getString('token');

  var url = Uri.parse(
      "https://admin.wasiljo.com/public/api/v1/delivery-boy/categories/2/subcategories");
  var response= await http.get(url,
    //   headers: {
    // 'Authorization': 'Bearer $token'}
  );
  if((response.statusCode>=200&& response.statusCode<300)){
    if(response.body.isEmpty){


      return ;}
      print(response.body);
      List listShop = json.decode(response.body)['data']['subcategories'];
      print(json.decode(response.body)['data']['subcategories']);
      log(listShop.length.toString());
      log("*****************************************************************");
      for (int i = 0; i < listShop.length; i++) {
        setState(() {
          subcategoryGas.add(SubcategoriesGas.fromJson(listShop[i]));
        });
        // shops.add(Shops.fromJson(listShopCategory[i]));
        print('subcategoryShops$subcategoryGas');
        print('subcategoryShops${listShop.length}');
      }
      return;
    }
  }

  void initState() {
    appUserData.data!.deliveryBoy!.categoryId == 1
        ? getItemShop()
        : getItemGas();
  }

  var form = GlobalKey<FormState>();
  SubCategory? selectedShop;
  SubcategoriesGas? selectedGas;
  List _options = ['water', 'Gaze'];
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translator.translate('Add New Item'),
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: form,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                appUserData.data!.deliveryBoy!.categoryId == 1
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: Spacing.fromLTRB(20, 16, 20, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Color(0xffdcdee3), width: 1.5),
                        ),
                        padding: EdgeInsets.all(10),
                        child: DropdownButton<SubCategory>(
                          isExpanded: true,
                          underline: Container(),
                          value: selectedShop,
                          borderRadius: BorderRadius.circular(20),
                          dropdownColor: Colors.white,
                          hint: Text(Translator.translate(
                              'please select Subcategory')),
                          // Set a default value if needed.
                          onChanged: (SubCategory? newValue) {
                            setState(() {
                              selectedShop = newValue!;
                            });
                            // Handle the selected category.
                          },
                          items: subcategoryShops
                              .map((shop) => DropdownMenuItem<SubCategory>(
                                    value: shop,
                                    child: Text(shop!.title.ar),
                                  ))
                              .toList(),
                        ))
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: Spacing.fromLTRB(20, 16, 20, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Color(0xffdcdee3), width: 1.5),
                        ),
                        padding: EdgeInsets.all(10),
                        child: DropdownButton<SubcategoriesGas>(
                          isExpanded: true,
                          underline: Container(),
                          value: selectedGas,
                          borderRadius: BorderRadius.circular(20),
                          dropdownColor: Colors.white,
                          hint: Text(Translator.translate(
                              'please select Subcategory')),
                          // Set a default value if needed.
                          onChanged: (SubcategoriesGas? newValue) {
                            setState(() {
                              selectedGas = newValue!;
                            });
                            // Handle the selected category.
                          },
                          items: subcategoryGas
                              .map((shop) => DropdownMenuItem<SubcategoriesGas>(
                                    value: shop,
                                    child: Text(shop!.title.ar),
                                  ))
                              .toList(),
                        )),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Translator.translate(
                          'Please enter your total amount');
                    }
                  },
                  keyBoard: TextInputType.number,
                  controller: totalcontoller!,
                  hintText: Translator.translate("total amount"),
                  prefixIconData: Icon(Icons.onetwothree_rounded),
                  onPrefixIconPress: () {
                    setState(() {});
                  },
                ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Translator.translate(
                          'Please enter your total amount');
                    }
                  },
                  keyBoard: TextInputType.number,
                  controller: availableController!,
                  hintText: Translator.translate("available amount"),
                  prefixIconData: Icon(Icons.onetwothree_rounded),
                  onPrefixIconPress: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(errorText, style: TextStyle(color: Colors.red)),
                ),

                SizedBox(
                  height: 12,
                ),
                CommonViews().createButton(
                  title: Translator.translate('Add New Item'),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var token = prefs.getString('token');
                    var headers = {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token'
                    };
                    var response = await http.post(
                        Uri.parse(
                            'https://admin.wasiljo.com/public/api/v1/delivery-boy/subcategories/select'),
                        body: json.encode([
                          {
                            "sub_category_id":
                                appUserData.data!.deliveryBoy!.categoryId == 1
                                    ? selectedShop!.id.toString()
                                    : selectedGas!.id,
                            "total_quantity": totalcontoller!.text,
                            "available_quantity": availableController!.text
                          }
                        ]),
                        headers: headers);

                    if (response.statusCode == 200) {
                      if (json.decode(response.body).containsKey('error')) {
                        setState(() {
                          errorText = json.decode(response.body)['error'];
                        });
                      } else {
                        Get.off(CategoryScreen());
                      }
                    } else {
                      print(response.body);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
