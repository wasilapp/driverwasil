import 'dart:developer';

import 'package:DeliveryBoyApp/models/boyData.dart';
import 'package:DeliveryBoyApp/views/category/widget/custom_textfaild.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/AppLocalizations.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/colors.dart';
import '../auth/CategoryController.dart';
import 'add_item/item_shop_mofel.dart';
import 'controller/CategoryController.dart';

class AddNewCategory extends StatefulWidget {
   AddNewCategory({Key? key});

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
TextEditingController totalcontoller=TextEditingController();

   CategoryController controller = Get.put(CategoryController());

   TextEditingController availableController=TextEditingController();

   Category_Controller category_Controller=Get.put(Category_Controller());

   var form=GlobalKey<FormState>();
SubCategory? selectedShop;
   List _options= ['water','Gaze'];

  @override
  Widget build(BuildContext context) {
    category_Controller.gettoken();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Item',style: TextStyle(color:primaryColor,fontWeight: FontWeight.bold,)),

      ),
      body: SingleChildScrollView(
        child: Form(
          key: form,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              children: [
                 Obx(() {
          if (controller.isWaiting) {
          return Text('mo');
          }
          if (controller.isError) {
          return Text('g');
          }
          return Container(
          height:
          MediaQuery.of(context).size.height * 0.06,
          margin: Spacing.fromLTRB(24, 16, 24, 0),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
          color: Color(0xffdcdee3), width: 1.5),
          ),
          padding: EdgeInsets.all(10),
          child: DropdownButton<SubCategory>(
          underline: Container(),
          value: selectedShop,
          borderRadius: BorderRadius.circular(20),
          dropdownColor: Colors.white,
          hint: Text(Translator.translate('please select Subcategory')),
          // Set a default value if needed.
          onChanged: (SubCategory? newValue) {
          setState(() {
          selectedShop = newValue!;

          });
          // Handle the selected category.
          },
          items: controller.subcategoryShops
              .map((shop) =>
          DropdownMenuItem<SubCategory>(
          value: shop,
          child: Text(shop!.title.en),
          ))
              .toList(),
          ));
          }),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: 0, vertical: 5),
                  child: CustomSearchableDropDown(
                    items: category_Controller.boydata?.subCategory??[],
                    label: 'Select Sup-Category',
                    menuMode: true,
                    menuHeight: 200,
                    hideSearch: false,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(0.0),
                    ),
                    dropDownMenuItems: category_Controller.boydata?.subCategory?.map((SubCategoryBoy item) {
                      return item.toString().replaceAll('_', ' ');
                    }).toList() ??
                        [],
                    onChanged: (value) {

                    },
                    multiSelect: false,
                  ),
                ),

                CutemTextFaild(

                  enbleBorder:true,

                  controler: totalcontoller,
                  lable: Text('total amount'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
                SizedBox(height: 10,),
                CutemTextFaild(
                  enbleBorder:true,
                  controler: availableController,
                  lable: Text('available amount'),

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  ),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                    onPressed: () {
                      category_Controller.addNewCategory(catgId:'1', totalamount: totalcontoller.text, availableAmount: availableController.text);
                    },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 8,
                      padding: EdgeInsets.all(6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    child: Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: Center(child: Text('Add New Item',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28),)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
