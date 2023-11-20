import 'dart:convert';

import 'package:DeliveryBoyApp/views/profile_view/show_driver.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:sizer/sizer.dart';

import '../../models/app_user_models.dart';
import '../../services/AppLocalizations.dart';
import '../../utils/colors.dart';
class ProfileScreen extends StatefulWidget {


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DeliveryBoyShow deliveryBoy=DeliveryBoyShow();
  initState() {
    super.initState();
    getDriver();
  }
  getDriver() async {
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
        deliveryBoy=DeliveryBoyShow.fromJson(jsonData['data']['deliveryBoy']);
      });
      print('ddd$deliveryBoy');
    }
    else {
      print(response.body);
    }

  }
  var onn=1;
  bool open=false;

  updateStatus(status)async{
    print("""""$status""");
    SharedPreferences prefs= await SharedPreferences.getInstance();
    var bearerToken=   prefs.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var request = http.Request('PUT', Uri.parse('https://news.wasiljo.com/public/api/v1/delivery-boy/update_profile'));
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

    }
    else {
      print(response.reasonPhrase);
    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(),
      body: deliveryBoy==null?Container(): Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Red Container
SizedBox(height: 30,),

                CircleAvatar(radius: 60,backgroundImage: NetworkImage('https://news.wasiljo.com/${deliveryBoy.avatarUrl}'),)
           ,
           Text(deliveryBoy.name?.ar.toString()??'',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 11.sp)),
            Text(deliveryBoy.email??'',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 11.sp) ),
            SizedBox(height: 30,),
            // Container with Text above the Red Container
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:Color(0xffF6F7F9),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child:             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),

                      decoration: BoxDecoration(
                          color: Color(0xffF6F7F9),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                 //         Icon(Icons.onetwothree_rounded,color: primaryColor),
                          Text(Translator.translate('Total'),style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 13.sp)),
                          Text('${deliveryBoy!.totalQuantity.toString()}',style: TextStyle(color:primaryColor,fontWeight: FontWeight.bold,fontSize: 15.sp)),

                        ],
                      ),
                    ),
                  ),
              Container(color: primaryColor,height: 30,width: 2),
                  Expanded(
                    child: Container(

                      margin: EdgeInsets.all(8),

                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [

                          Text(Translator.translate('empty'),style: TextStyle(color:primaryColor,fontWeight: FontWeight.bold,fontSize: 11.sp)),
                          Text('${(appUserData.data!.deliveryBoy!.totalQuantity!- appUserData.data!.deliveryBoy!.availableQuantity!).toString()}',style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 15.sp)),

                        ],
                      ),
                    ),
                  ),
                  Container(color: primaryColor,height: 30,width: 2),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),

                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                        //  Icon(Icons.onetwothree_rounded),
                          Center(child: Text(Translator.translate('not Empty'),style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 11.sp))),
                          Text('${appUserData.data!.deliveryBoy!.availableQuantity!.toString()}',style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 15.sp)),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        SizedBox(height: 20,),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color:Color(0xffF6F7F9),
            borderRadius: BorderRadius.circular(8.0),
          ),child:   Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.car_crash,color: primaryColor),
                        SizedBox(width: 5,),
                        Text ( Translator.translate("car number :"),),
                      ],
                    ),
                    Text(deliveryBoy.carNumber.toString()),

                  ],
                ),Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                children: [ Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.category,color: primaryColor),
                        SizedBox(width: 5,),
                        Text ( Translator.translate("Type services :"),),
                      ],
                    ),


                  ],
                ), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                children: [Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.phone_android,color: primaryColor),
                        SizedBox(width: 5,),
                        Text ( Translator.translate("mobile number :"),),
                      ],
                    ),
                    Text(deliveryBoy.mobile.toString()),

                  ],
                ),Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.start,
                children: [ Row(
                      children: [
                        Icon(Icons.star_sharp,color: primaryColor),
                        SizedBox(width: 5,),
                        Text ( Translator.translate("Rating :"),),
                      ],
                    ),
                    Text(deliveryBoy.rating.toString()),

                  ],
                ),
            ],
          ))
          ],
        ),
      ),
    ));
  }
}
