import 'package:DeliveryBoyApp/models/app_user_models.dart';
import 'package:DeliveryBoyApp/utils/toast.dart';
import 'package:DeliveryBoyApp/views/category/cayegory_screen.dart';
import 'package:DeliveryBoyApp/views/transaction/TransactionScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:DeliveryBoyApp/AppTheme.dart';
import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:DeliveryBoyApp/services/firestore_services.dart';
import 'package:DeliveryBoyApp/views/SelectLanguageDialog.dart';
import 'package:DeliveryBoyApp/views/SelectThemeDialog.dart';
import 'package:DeliveryBoyApp/views/auth/login/LoginScreen.dart';
import 'package:DeliveryBoyApp/views/auth/edit_profile/edit_profile_view.dart';
import 'package:DeliveryBoyApp/views/detail_order/detail_order.dart';

import '../profile_view/profile_view.dart';
import 'order_controller.dart';
import 'order_model.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int driverStatus = 0;

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late FirestoreServices firestoreServices;
  // DeliveryBoyModel? deliveryBoy;
  // AuthController controller = Get.put(AuthController());
  GetOrderController orderController = Get.put(GetOrderController());
  // AuthController authController = Get.put(AuthController());
  AuthControllerr authControllerr = Get.put(AuthControllerr());
  TabController? tabController;
  @override
  void initState() {
    print(
        '==========>${authControllerr.boysDeliveryData?.data?.deliveryBoy?.categoryId}');
    orderController.getOrders();
    tabController = TabController(length: 2, vsync: this);
    getLang();
    super.initState();
  } //ThemeData

  String? langCode;
  getLang() async {
    langCode = await AllLanguage.getLanguage();
    print("ppppppppppppppppp$langCode");
  }

  ThemeData? themeData;
  CustomAppTheme? customAppTheme;

  static const List<String> _options = <String>[
    'all',
    'assign_shop_to_delivery',
    'accepted_by_driver',
    'on_the_way',
    'delivered',
    'rejected_by_driver',
    'cancelled_by_driver',
  ];
  String _selectedOption = "all";
  bool switchData = false;
  //Global Key
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Stream<LocationData>? data;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          if (driverStatus == 0) {
            data = Location.instance.getLocation().asStream();
            data!.listen((event) {
              // appUserData.data!.deliveryBoy!.latitude =
              //     event.latitude!.toString();
              // appUserData.data!.deliveryBoy!.longitude =
              //     event.longitude!.toString();
              Get.log(appUserData.data!.token!);
              appUserData.data!.deliveryBoy!.isActive = driverStatus;
              setState(() {
                driverStatus = 1;
              });
              Get.find<AuthControllerr>().saveDeliveryBoyData(appUserData);
            });
          } else {
            appUserData.data!.deliveryBoy!.isActive = driverStatus;
            setState(() {
              driverStatus = 1;
            });
            Get.find<AuthControllerr>().saveDeliveryBoyData(appUserData);
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          width: MediaQuery.sizeOf(context).width,
          height: 60,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              driverStatus == 0 ? 'Online' : 'Offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: primaryColor,
        width: 250,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  // InkWell(
                  //   onTap:(){
                  //    // _getImage();
                  //   },
                  //   child: Container(
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.all(
                  //           Radius.circular(MySize.getScaledSizeWidth(60))),
                  //       child: imageFile==null ?  ImageUtils.getImageFromNetwork(
                  //           deliveryBoy!.getAvatarUrl(),
                  //           width: 50,
                  //           height: 50) :  Image.file(
                  //         imageFile!,
                  //         height: MySize.getScaledSizeWidth(120),
                  //         width: MySize.getScaledSizeWidth(120),
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(deliveryBoy!.agencyName!,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      // Text(deliveryBoy!.email!,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(),
                  ),
                );
              },
              leading: Icon(
                MdiIcons.shopping,
                color: backgroundColor,
              ),
              title: Text(
                Translator.translate("Order"),
                style: TextStyle(
                    color: backgroundColor, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(MdiIcons.chevronRight, color: backgroundColor),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfileScreen(),
                  ),
                );
              },
              leading: Icon(
                Icons.person,
                color: backgroundColor,
              ),
              title: Text(
                Translator.translate("Profile"),
                style: TextStyle(
                    color: backgroundColor, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(MdiIcons.chevronRight, color: backgroundColor),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CategoryScreen(),
                  ),
                );
              },
              leading: Icon(
                MdiIcons.shopping,
                color: backgroundColor,
              ),
              title: Text(
                Translator.translate("Category"),
                style: TextStyle(
                    color: backgroundColor, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(MdiIcons.chevronRight, color: backgroundColor),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditProfileScreen(),
                  ),
                );
              },
              leading: Icon(
                Icons.edit,
                color: backgroundColor,
              ),
              title: Text(
                Translator.translate("EditProfileScreen"),
                style: TextStyle(
                    color: backgroundColor, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(MdiIcons.chevronRight, color: backgroundColor),
            ),
            SizedBox(
              height: 15,
            ),
            // ListTile(
            //   visualDensity: VisualDensity.compact,
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (BuildContext context) => SelectLanguageDialog());
            //   },
            //   leading: Icon(
            //     MdiIcons.translate,
            //     color: backgroundColor,
            //   ),
            //   title: Text(
            //     Translator.translate("select_language"),
            //     style: TextStyle(
            //         color: backgroundColor, fontWeight: FontWeight.w600),
            //   ),
            //   trailing: Icon(MdiIcons.chevronRight, color: backgroundColor),
            // ),

            // ListTile(
            //   visualDensity: VisualDensity.compact,
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: (BuildContext context) => SelectThemeDialog());
            //   },
            //   leading: Icon(
            //     MdiIcons.eyeOutline,
            //     color: backgroundColor,
            //   ),
            //   title: Text(
            //     Translator.translate("Theme"),
            //     style: TextStyle(
            //         color: backgroundColor, fontWeight: FontWeight.w600),
            //   ),
            //   trailing: Icon(MdiIcons.chevronRight, color: backgroundColor),
            // ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => TransactionScreen(),
                  ),
                );
              },
              leading: Icon(
                MdiIcons.currencyUsd,
                color: backgroundColor,
              ),
              title: Text(
                Translator.translate("Transaction"),
                style: TextStyle(
                    color: backgroundColor, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(MdiIcons.chevronRight, color: backgroundColor),
            ),
            Spacer(),
            Divider(
              color: backgroundColor,
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              onTap: () async {
                HomeScreen();

                await AuthController.logoutUser();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                );
              },
              leading: Icon(
                MdiIcons.logoutVariant,
                color: backgroundColor,
              ),
              title: Text(
                Translator.translate("Logout"),
                style: TextStyle(
                    color: backgroundColor, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      body:
          // Content for Tab 1
          authControllerr.boysDeliveryData?.data?.deliveryBoy?.categoryId == 2
              ? Column(
                  children: [
                    TabBar(
                      controller: tabController,
                      tabs: [
                        Tab(text: 'Scaduled Order'),
                        Tab(text: 'Urgent Order'),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height,
                        child: TabBarView(controller: tabController, children: [
                          ListView(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: CustomSearchableDropDown(
                                  items: _options,
                                  label: 'filter status',
                                  menuMode: true,
                                  menuHeight: 200,
                                  hideSearch: false,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor)),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  dropDownMenuItems: _options.map((item) {
                                    return item.replaceAll('_', ' ');
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value;
                                      orderController.status.value =
                                          _selectedOption;
                                      orderController.getOrders();
                                      print(orderController.orders);
                                    });
                                    // if (value != null) {
                                    //   selected = value['class'].toString();
                                    // } else {
                                    //   selected = null;
                                    // }
                                  },
                                  multiSelect: false,
                                ),
                              ),
                              Obx(() {
                                if (orderController.isWaiting) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor:
                                                Colors.grey.shade300,
                                            child: Container(
                                              height: 160,
                                              width: 100,
                                              color: Colors.grey,
                                            )),
                                      );
                                    },
                                    itemCount: 10,
                                  );
                                }
                                if (orderController.isError) {
                                  return Center(
                                    child: Text(orderController
                                        .statusModel.value.errorMsg!.value),
                                  );
                                }
                                print(
                                    "==> ${orderController.orders.length} <==");

                                return ListView.builder(
                                  padding: EdgeInsets.only(bottom: 12),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return buildOrder(
                                        orderController.orders[index]);
                                  },
                                  itemCount: orderController.orders.length,
                                  shrinkWrap: true,
                                );
                              }),
                            ],
                          ),
                          ListView(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    orderController.getOrders();
                                  },
                                  child: Text('show')),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: CustomSearchableDropDown(
                                  items: _options,
                                  label: 'filter status',
                                  menuMode: true,
                                  menuHeight: 200,
                                  hideSearch: false,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor)),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  dropDownMenuItems: _options.map((item) {
                                    return item.replaceAll('_', ' ');
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value;
                                      orderController.status.value =
                                          _selectedOption;
                                      orderController.getOrders();
                                      print(orderController.orders);
                                    });
                                    // if (value != null) {
                                    //   selected = value['class'].toString();
                                    // } else {
                                    //   selected = null;
                                    // }
                                  },
                                  multiSelect: false,
                                ),
                              ),
                              Obx(() {
                                if (orderController.isWaiting) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor:
                                                Colors.grey.shade300,
                                            child: Container(
                                              height: 160,
                                              width: 100,
                                              color: Colors.grey,
                                            )),
                                      );
                                    },
                                    itemCount: 10,
                                  );
                                }
                                if (orderController.isError) {
                                  return Center(
                                    child: Text(orderController
                                        .statusModel.value.errorMsg!.value),
                                  );
                                }
                                print(
                                    "==> ${orderController.orders.length} <==");

                                return ListView.builder(
                                  padding: EdgeInsets.only(bottom: 12),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return buildOrder(
                                        orderController.orders[index]);
                                  },
                                  itemCount: orderController.orders.length,
                                  shrinkWrap: true,
                                );
                              }),
                            ],
                          ),
                        ]),
                      ),
                    )
                  ],
                )
              : Container(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      Material(
                        elevation: 10,
                        color: Colors.white,
                        child: CustomSearchableDropDown(
                          items: _options,
                          label: 'filter status',
                          menuMode: true,
                          menuHeight: 200,
                          hideSearch: false,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xffeef2fa))),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(0.0),
                          ),
                          dropDownMenuItems: _options.map((item) {
                            return item.replaceAll('_', ' ');
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value;
                              orderController.status.value = _selectedOption;
                              orderController.getOrders();
                              print(orderController.orders);
                            });
                          },
                          multiSelect: false,
                        ),
                      ),
                      Obx(() {
                        if (orderController.isWaiting) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Shimmer.fromColors(
                                    baseColor: borderColor,
                                    highlightColor: borderColor,
                                    child: Container(
                                      height: 160,
                                      width: 100,
                                      color: borderColor,
                                    )),
                              );
                            },
                            itemCount: 10,
                          );
                        }
                        if (orderController.isError) {
                          return Center(
                            child: Text(orderController
                                .statusModel.value.errorMsg!.value),
                          );
                        }
                        print("==> ${orderController.orders.length} <==");

                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: 12),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return orderController.orders.length == 0
                                ? Text(
                                    'not',
                                    style: TextStyle(color: Colors.black),
                                  )
                                : buildOrder(orderController.orders[index]);
                          },
                          itemCount: orderController.orders.length,
                          shrinkWrap: true,
                        );
                      }),
                    ],
                  ),
                ),
    ));
  }

  buildOrder(OrdersModel model) {
    return Container(
      padding: Spacing.all(16),
      margin: Spacing.only(top: 1.h, bottom: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
        color: Colors.white,
        border: Border.all(color: const Color(0xffeef2fa), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${Translator.translate('Order Id :')}' + '${model.id}',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                langCode == 'ar'
                    ? '${model.statu!.title!.ar}'
                    : '${model.statu!.title!.en}',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // Icon(
              //   Icons.location_pin,
              //   color: primaryColor,
              // ),
              Text(
                //    Translator.translate('Street name :') +
                '${model.address!.street}',
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icon(
                  //   Icons.price_change_outlined,
                  //   color: primaryColor,
                  // ),
                  Text(
                    Translator.translate('Total price :') + '${model.total!}',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Translator.translate('Order Date:') +
                '${model.orderTime!.orderDate.toString()}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                letterSpacing: 0),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            Translator.translate('Order Time:') +
                '${model.orderTime!.orderTimeFrom}-${model.orderTime!.orderTimeTo}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                letterSpacing: 0),
          ),
          Row(
            children: [
              model.status == 3
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              orderController.changeStatus(
                                  model.id, 'accepted');
                            },
                            child: Text(Translator.translate('accepted'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                elevation: 5,
                                padding: EdgeInsets.all(6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              orderController.changeStatus(
                                  model.id, 'rejected');
                            },
                            child: Text(Translator.translate('rejected'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                elevation: 5,
                                padding: EdgeInsets.all(6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                      ],
                    )
                  : Container(),
              model.status == 5
                  ? ElevatedButton(
                      onPressed: () {
                        orderController.changeStatus(model.id, 'delivered');
                      },
                      child: Text(Translator.translate('delivered'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(.8),
                          elevation: 8,
                          padding: EdgeInsets.all(6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))))
                  : Container(),
              model.status == 6
                  ? ElevatedButton(
                      onPressed: () {
                        showtoast(
                            text:
                                Translator.translate("order already delivered"),
                            state: ToastStates.ERROR);
                        // orderController.changeStatus(model.id, 'delivered');
                      },
                      child: Text(Translator.translate('delivered done'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(.8),
                          elevation: 0,
                          padding: EdgeInsets.all(6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))))
                  : Container(),
              model.status == 4
                  ? ElevatedButton(
                      onPressed: () {
                        orderController.changeStatus(model.id, 'on_the_way');
                      },
                      child: Text(Translator.translate('Go on the Way'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 8,
                          padding: EdgeInsets.all(6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))))
                  : Container(),
              Spacer(),
              InkWell(
                child: Text(Translator.translate('view detail')),
                onTap: () => Get.to(OrderDetail(
                  model: model,
                )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
