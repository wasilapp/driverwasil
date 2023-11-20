import 'dart:convert';

import 'package:DeliveryBoyApp/api/api.dart';
import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../auth/CategoryController.dart';
import 'addNewCategory.dart';
import 'add_item/my_items_model.dart';
import 'controller/CategoryController.dart';

class CategoryScreen extends StatefulWidget {
   CategoryScreen({Key? key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
   var mySubcategoryShops = [];

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
         setState(() {
           mySubcategoryShops.add(MySubCategories.fromJson(listShop[i]));
         });
         // shops.add(Shops.fromJson(listShopCategory[i]));
         print(' myyyyyyyyysubcategoryShops$mySubcategoryShops');
         print(' my subcategoryShops${listShop.length}');
       }
       return;
     }



   }

   void initState(){
print('start');
   getMyItemShop();
   }

   AuthControllerr authControllerr=Get.put(AuthControllerr());

   CategoryController categoryController=Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();
    return
      RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            getMyItemShop();

            },
      child: Scaffold(
        appBar: AppBar(
          title: Text('المنتجات',style: TextStyle(color: Colors.black),),
        ),
        ///api/v1/delivery-boy/mySubCategories
        body:
        Column(children: [

      ListView.builder(shrinkWrap: true,
            padding: EdgeInsets.only(top: 20),
              itemCount:mySubcategoryShops.length,
             itemBuilder: (context, index) {
            print('kkkkk');
               var item=mySubcategoryShops[index];
               print("2222222222222${mySubcategoryShops.length}2222222222222222");
               print("2222222222222${mySubcategoryShops}2222222222222222");
              return ItemStock(
                id:  item.id,
                image:  item.imageUrl,
                name: item.title.en,
                avilable: item.details?.availableQuantity??'0',
                total: item.details?.totalQuantity??'0',);

             },
              )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewCategory()));
           getMyItemShop();
          },
          child: Icon(Icons.add),

        ),
      ),
    );
  }

   Widget ItemStock({required String image,required String name,required String? avilable,required String? total,required id })=>Card(
     elevation: 8,
     margin: EdgeInsets.all(20),
     //shadowColor: primaryColor.withOpacity(.6),
     shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(10)
     ),
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           SizedBox(
             height: 10,
           ),
           Card(
             elevation: 0,
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10)
             ),
             child: Container(
                 width: 90,
                 height: 90,
                 child: Image.network(Api.BASE_URL.replaceAll('public/','')+image
                   ,
                 )
               // CachedNetworkImage(
               //   imageUrl: '${Api.BASE_URL.replaceAll('public/','')}${order.carts?.firstWhere((element) => element.orderId==order.id,).subcategory?.image??''}',
               //   height: 60,
               //   placeholder: (BuildContext, String)=>Center(
               //     child: CircularProgressIndicator(color: primaryColor.withOpacity(.6)),
               //   ),
               //  errorWidget: (BuildContext, String, Object)=>Icon(Icons.person,color: Colors.grey,),
               // ),
             ),
           ),
           SizedBox(width: 3,),
           Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SizedBox(
                 height: 10,
               ),
               Row(
                 children: [
                   //Icon(Icons.perm_identity, color: primaryColor),
                   // Text('Item name: ',
                   //     style: TextStyle(fontWeight: FontWeight.bold)),
                   //Text('${order.carts?.firstWhere((element) => element.orderId==order.id,).subcategory?.title?.ar??''}'),
                   //  SizedBox(width: 3,),
                   //Text('/',style: TextStyle(fontWeight: FontWeight.bold)),
                   Text('${name??''}',   style: TextStyle(fontWeight: FontWeight.bold)),

                 ],
               ),
               SizedBox(
                 height: 10,
               ),


               Row(
                 children: [
                  // Icon(Icons.attach_money, color: primaryColor),
                   SizedBox(
                     width: 2,
                   ),
                   Text('Total  :',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                   Text('${total??0}'),
                   SizedBox(
                     width: 8,
                   ),

                   Text('available  :',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                   Text('${avilable??0}'),

                 ],
               ),
               SizedBox(
                 height: 10,
               ),
               Row(

                 children: [
                   GestureDetector(
                       onTap: () async {
                         SharedPreferences prefs=await SharedPreferences.getInstance();
                         var token=prefs.getString('token');

                         var headers = {
                           'Authorization': 'Bearer $token'
                         };
                         var request = http.Request('POST', Uri.parse('https://news.wasiljo.com/public/api/v1/delivery-boy/subcategories/remove/${id.toString()}'));

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




                       },

                       child: Row(
                         children: [
                           Icon(Icons.delete,color: Colors.red,),
                           Text('Delete',style: TextStyle(color: Colors.red),),

                         ],
                       )),
                   SizedBox(width: 12,),
                   // GestureDetector(
                   //     onTap: (){
                   //     },
                   //
                   //     child: Row(
                   //       children: [
                   //         Icon(Icons.visibility_off,color: Colors.grey,),
                   //         Text('hide',),
                   //
                   //       ],
                   //     )),
                 ],
               ),

             ],
           ),

           // Row(
           //   children: [
           //     Icon(Icons.phone, color: primaryColor),
           //     Text(' delevery dee :',
           //         style: TextStyle(fontWeight: FontWeight.bold)),
           //     Text('${order.!.mobile}'),
           //   ],
           // ),

         ],
       ),
     ),
   );
}
