import 'package:DeliveryBoyApp/api/api.dart';
import 'package:DeliveryBoyApp/utils/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/colors.dart';
import '../order/order_controller.dart';
import '../order/order_model.dart';

class OrderDetail extends StatefulWidget {
  final OrdersModel model;

  const OrderDetail({Key? key, required this.model}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    GetOrderController orderController = Get.put(GetOrderController());
    var order = widget.model;
    double totalCoust = 0.0;
    order.carts?.forEach((element) {
      totalCoust = totalCoust +
          ((element.quantity ?? 0) * (element.subcategory?.price ?? 0));
    });
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Container(
        width: double.infinity,
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(color: Colors.white),
        //todo accept or reject states ==3
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            order.status == 3
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              orderController.changeStatus(
                                  order.id, 'accepted');
                            },
                            clipBehavior: Clip.hardEdge,
                            child: Text('accepted',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 5,
                                padding: EdgeInsets.all(6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              orderController.changeStatus(
                                  order.id, 'rejected ');
                            },
                            child: Text('rejected ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                elevation: 5,
                                padding: EdgeInsets.all(6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                      ),
                    ],
                  )
                : order.status == 6
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  showtoast(
                                      text: "order already delivered",
                                      state: ToastStates.ERROR);

                                  // orderController.changeStatus(
                                  //     order.id, 'delivered');
                                },
                                child: Text('delivered done',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    elevation: 0,
                                    padding: EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              orderController.openPhoneDialer(
                                  phone: order.user!.mobile.toString());
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: primaryColor)),
                              child: Icon(Icons.phone, color: primaryColor),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () {
                              orderController.openMap(
                                  latitude: order.latitude,
                                  longitude: order.longitude);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: primaryColor)),
                              child: Icon(Icons.location_on_outlined,
                                  color: primaryColor),
                            ),
                          ),
                        ],
                      )
                    : order.status == 4
                        ? Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      orderController.changeStatus(
                                          order.id, 'on_the_way');
                                    },
                                    clipBehavior: Clip.hardEdge,
                                    child: Text('Go on the way',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        elevation: 5,
                                        padding: EdgeInsets.all(6),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  orderController.openPhoneDialer(
                                      phone: order.user!.mobile.toString());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: primaryColor)),
                                  child: Icon(Icons.phone, color: primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  orderController.openMap(
                                      latitude: order.latitude,
                                      longitude: order.longitude);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: primaryColor)),
                                  child: Icon(Icons.location_on_outlined,
                                      color: primaryColor),
                                ),
                              ),
                            ],
                          )
                        : order.status == 5
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          orderController.changeStatus(
                                              order.id, 'deleverd');
                                        },
                                        child: Text('delivered',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            elevation: 5,
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ))),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      orderController.openPhoneDialer(
                                          phone: order.user!.mobile.toString());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: primaryColor)),
                                      child: Icon(Icons.phone,
                                          color: primaryColor),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      orderController.openMap(
                                          latitude: order.latitude,
                                          longitude: order.longitude);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: primaryColor)),
                                      child: Icon(Icons.location_on_outlined,
                                          color: primaryColor),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
          ],
        ),
      ),
      appBar: AppBar(
          title: Text(' Detail Order ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)))),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              // decoration: BoxDecoration(border: Border.all(color: borderColor,width: 1.5)),
              margin: EdgeInsets.all(18),
              //padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //  Text('User'),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.perm_identity, color: primaryColor),
                              // Text('User Name :',
                              //     style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.user!.name}'),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  orderController.openPhoneDialer(
                                      phone: order.user!.mobile.toString());
                                },
                                child: Icon(
                                  Icons.phone_android,
                                  color: primaryColor,
                                ),
                              ),
                              // Text(' mobile :',
                              //     style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.user!.mobile}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Card(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            orderController.openMap(
                                latitude: order.latitude,
                                longitude: order.longitude);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  color: primaryColor),
                              SizedBox(
                                width: 2,
                              ),
                              Text('Street name :',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('${order.address!.street}'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.home_work_outlined, color: primaryColor),
                            SizedBox(
                              width: 2,
                            ),
                            Text('building Number :',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${order.address!.buildingNumber}'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(Icons.apartment, color: primaryColor),
                            SizedBox(
                              width: 2,
                            ),
                            Text('apartment Number :',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${order.address!.apartmentNum}'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Order Date ${order.orderTime!.orderDate}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Order Time ${order.orderTime!.orderTimeFrom.toString()}' +
                                '-' +
                                '${order.orderTime!.orderTimeTo.toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.price_change,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'total ${totalCoust}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.price_change,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Visibility(
                            visible: order.orderPayment!.paymentType == 2,
                            child: Text(
                              'payment type : Cash',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Visibility(
                            visible: order.orderPayment!.paymentType == 1,
                            child: Text(
                              'payment type : Coupon Book',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            for (Carts item in order.carts ?? [])
              Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: 90,
                                height: 90,
                                child: Image.network(
                                  '${Api.BASE_URL.replaceAll('public/', '')}${item.subcategory?.imageUrl ?? ''}',
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
                          SizedBox(
                            width: 3,
                          ),
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
                                  Text('Item name: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  //Text('${order.carts?.firstWhere((element) => element.orderId==order.id,).subcategory?.title?.ar??''}'),
                                  //  SizedBox(width: 3,),
                                  //Text('/',style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${item.subcategory?.title?.en ?? ''}'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text('Amount :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('${item.quantity ?? ''}'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text('Total Price :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('${(item.total ?? 0)}'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
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
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
