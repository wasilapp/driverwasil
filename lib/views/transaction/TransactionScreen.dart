import 'dart:convert';

import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/api/currency_api.dart';
import 'package:DeliveryBoyApp/controllers/TransactionController.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/models/Transaction.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/views/LoadingScreens.dart';
import 'package:DeliveryBoyApp/views/transaction/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import '../../models/transActionModel.dart';
import '../../utils/colors.dart';
import '../auth/authControllernew.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  DeliveryBoyTransaction ? deliveryBoy;
  getTransaction() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var token=prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token'
    };
    var response =await  http.get(
      Uri.parse('https://news.wasiljo.com/public/api/v1/delivery-boy/get_transaction_order'),
      headers: headers,

    );





    if (response.statusCode == 200) {
      print(await response.body);
      final jsonData = json.decode(response.body);
      setState(() {
        deliveryBoy=DeliveryBoyTransaction.fromJson(jsonData['data']['deliveryBoy']);
      });
      print('ddd$deliveryBoy');
    }
    else {
      print(response.body);
    }

  }
  initState() {
    super.initState();
    getTransaction();
  }





  Widget build(BuildContext context) {

        return Scaffold(

              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(MdiIcons.chevronLeft,color: Colors.black,size: MySize.size20,),
                ),
                elevation: 0,
                centerTitle: true,
                title: Text(
                  Translator.translate("transactions"),

                ),
              ),
              body:deliveryBoy==null?Container(): Column(
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //
                  //         margin:EdgeInsets.symmetric(horizontal: 6),
                  //         decoration: BoxDecoration(
                  //             color: primaryColor.withOpacity(.3),
                  //             borderRadius: BorderRadius.circular(10)
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //
                  //           children: [
                  //             Text('Total Capacity'),
                  //             Text('${authControllerr.boysDeliveryData?.data?.deliveryBoy?.totalCapacity}'),
                  //
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         margin:EdgeInsets.symmetric(horizontal: 6),
                  //         decoration: BoxDecoration(
                  //             color: primaryColor.withOpacity(.3),
                  //             borderRadius: BorderRadius.circular(10)
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //
                  //           children: [
                  //             Text('Total Quantity'),
                  //             Text('${authControllerr.boysDeliveryData?.data?.deliveryBoy?.totalQuantity}'),
                  //
                  //
                  //           ],
                  //         ),
                  //       ),
                  //     )
                  //     ,
                  //     Expanded(
                  //       child: Container(
                  //         margin:EdgeInsets.symmetric(horizontal: 6),
                  //         decoration: BoxDecoration(
                  //             color: primaryColor.withOpacity(.3),
                  //             borderRadius: BorderRadius.circular(10)
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //           children: [
                  //             Text('Available Quantity'),
                  //             Text('${authControllerr.boysDeliveryData?.data?.deliveryBoy?.availableQuantity}'),
                  //
                  //
                  //           ],
                  //         ),
                  //       ),
                  //     )
                  //     ,
                  //   ],
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(

                          margin:EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: [
                              Icon(Icons.price_change_outlined),
                              Text('Total Order',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp)),
                              Text('${deliveryBoy!.orderTotal.toString()}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp)),

                            ],
                          ),
                        ),
                      ),     Expanded(
                        child: Container(

                          margin:EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: [
                              Icon(Icons.onetwothree_rounded),
                              Text('Numbers Order',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp)),
                              Text('${deliveryBoy!.orders!.length.toString()}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp)),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                Container(width: double.infinity,margin: EdgeInsets.all(20),
                  child: DataTable(columnSpacing: 0,border: TableBorder(horizontalInside: BorderSide(color: Colors.black12)),
                  columns: [
                    DataColumn(label: Expanded(child: Center(child: Text('Id')))),
                    DataColumn(label: Expanded(child: Center(child: Text('total')))),


        ],
        rows: deliveryBoy!.orders!.map((order) {
        return DataRow(cells: [
        DataCell(Center(child: Text(order.id.toString()))),
        DataCell(Center(child: Text(order.total.toString()))),

        ]);
        }).toList(),
              ),
                ),
              ],
              ));

  }





}
