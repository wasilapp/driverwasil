import 'package:DeliveryBoyApp/api/api.dart';
import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addNewCategory.dart';
import 'controller/CategoryController.dart';

class CategoryScreen extends StatelessWidget {
   CategoryScreen({Key? key});
  Category_Controller category_Controller=Get.put(Category_Controller());
   AuthControllerr authControllerr=Get.put(AuthControllerr());
  @override
  Widget build(BuildContext context) {
    category_Controller.getDeliveryBoyData();
    category_Controller.getCategoryData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Category',style: TextStyle(color: Colors.black),),
      ),
      ///api/v1/delivery-boy/mySubCategories
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          GetBuilder(
            builder: (Category_Controller controller) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 60),
                  itemCount:     category_Controller.myCategory?.subCategories.length??0,
                  itemBuilder:(context,index)=>ItemStock(
                    id:  category_Controller.myCategory?.subCategories[index].id,
                    image:  category_Controller.myCategory!.subCategories[index].imageUrl,
                    name:  category_Controller.myCategory!.subCategories[index].title!['en']??'',
                    avilable: category_Controller.myCategory!.subCategories[index].details?.availableQuantity??'0',
                    total: category_Controller.myCategory!.subCategories[index].details?.totalQuantity??'0',) );
            }
          ),
          Container(
            height: 60,
            width: double.infinity,

            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Container(

                    margin:EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Text('Total Capacity'),
                        Text('${authControllerr.boysDeliveryData?.data?.deliveryBoy?.totalCapacity}'),

                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Text('Total Quantity'),
                        Text('${authControllerr.boysDeliveryData?.data?.deliveryBoy?.totalQuantity}'),


                      ],
                    ),
                  ),
                )
                ,
                Expanded(
                  child: Container(
                    margin:EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Available Quantity'),
                        Text('${authControllerr.boysDeliveryData?.data?.deliveryBoy?.availableQuantity}'),


                      ],
                    ),
                  ),
                )
                ,
              ],
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewCategory()));
        },
        child: Icon(Icons.add),

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
                       onTap: (){
                         category_Controller.deleteCategory(id: id.toString());

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
