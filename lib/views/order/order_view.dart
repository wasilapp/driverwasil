//import 'package:DeliveryBoyApp/models/DeliveryBoy.dart';
import 'package:DeliveryBoyApp/utils/toast.dart';
import 'package:DeliveryBoyApp/views/category/cayegory_screen.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../AppTheme.dart';

import '../../controllers/OrderController.dart';

import '../../custom_bakage.dart';
import '../../services/AppLocalizations.dart';
import '../../services/firestore_services.dart';
import '../../services/not.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/colors.dart';
import '../AppScreen.dart';
import '../RevenueStatScreen.dart';
import '../SelectLanguageDialog.dart';
import '../SelectThemeDialog.dart';
import '../auth/LoginScreen.dart';

import '../auth/edit_profile/edit_profile_view.dart';
import '../detail_order/detail_order.dart';
import 'order_controller.dart';
import 'order_model.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

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
  String ?langCode;
  getLang() async {
    langCode = await AllLanguage.getLanguage();print("ppppppppppppppppp$langCode");
  }
  ThemeData? themeData;
  CustomAppTheme? customAppTheme;

  static const List<String> _options = <String>[
    'all',
    // 'pending',
    // 'accepted_by_shop',
    'assign_shop_to_delivery',
    'accepted_by_driver',
    'on_the_way',
    'delivered',
    // 'reviewed',
    // 'rejected_by_shop',
    'rejected_by_driver',
    // 'cancelled_by_user',
    // 'cancelled_by_shop',
    'cancelled_by_driver',
  ];
  String _selectedOption = "all";

  //Global Key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  new GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(elevation: 0),
          // title: Text('Order Screen',
          //     style:
          //         TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
          // centerTitle: true,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         bottomRight: Radius.circular(10),
          //         bottomLeft: Radius.circular(10)))),
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
                    Icons.person_2_outlined,
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
                ListTile(
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => SelectLanguageDialog());
                  },
                  leading: Icon(
                    MdiIcons.translate,
                    color: backgroundColor,
                  ),
                  title: Text(
                    Translator.translate("select_language"),
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
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => SelectThemeDialog());
                  },
                  leading: Icon(
                    MdiIcons.eyeOutline,
                    color: backgroundColor,
                  ),
                  title: Text(
                    Translator.translate("Theme"),
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
                        builder: (BuildContext context) => HomeScreen(),
                      ),
                    );
                  },
                  leading: Icon(
                    MdiIcons.currencyUsd,
                    color: backgroundColor,
                  ),
                  title: Text(
                    Translator.translate("Trnsaction"),
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
          // appBar: AppBar(
          //   backgroundColor: customAppTheme!.bgLayer2,
          //   elevation: 0,
          //   centerTitle: true,
          //   title: Text(
          //     Translator.translate("orders"),
          //     style: AppTheme.getTextStyle(themeData!.textTheme.headline6,
          //         color: themeData!.colorScheme.onBackground,
          //         fontWeight: 600),
          //   ),
          //   actions: [
          //     Container(
          //       margin: EdgeInsets.only(right: 10),
          //       padding: Spacing.all(10),
          //       decoration: BoxDecoration(
          //         color:
          //         deliveryBoy!.isOffline!
          //             ? Colors.red
          //             : primaryColor,
          //         border: Border.all(
          //             width: 1.2,
          //             color: deliveryBoy!.isOffline!
          //                 ? customAppTheme!.bgLayer4
          //                 : themeData!.colorScheme.primary),
          //         borderRadius:
          //         BorderRadius.all(Radius.circular(MySize.size5!)),
          //       ),
          //       child: InkWell(
          //
          //         onTap: () {
          //           print('ss${deliveryBoy!.isOffline!}');
          //         _changeStatus();
          //           print('sss${deliveryBoy!.isOffline!}');
          //         },
          //         child: Row(
          //           children: [
          //
          //             Text(
          //               deliveryBoy!.isOffline! ? Translator.translate("offline") : Translator.translate("online") ,
          //               style: AppTheme.getTextStyle(
          //                   themeData!.textTheme.bodyText2,
          //                   fontWeight: 600,
          //                   color: deliveryBoy!.isOffline!
          //                       ? backgroundColor
          //                       : backgroundColor),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //
          //   ],
          // ),
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
                            }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                orderController.status.value =
                                    _selectedOption;
                                orderController.getOrders();
                                print(orderController.orders.value);
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
                            }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                                orderController.status.value =
                                    _selectedOption;
                                orderController.getOrders();
                                print(orderController.orders.value);
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
            child: ListView(padding: EdgeInsets.symmetric(vertical: 8),
              children: [

                Material(elevation: 10,color: Colors.white,
                  child: CustomSearchableDropDown(
                    items: _options,
                    label: 'filter status',
                    menuMode: true,
                    menuHeight: 200,
                    hideSearch: false,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xffeef2fa)
                        )),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(0.0),
                    ),
                    dropDownMenuItems: _options.map((item) {
                      return item.replaceAll('_', ' ');
                    }).toList() ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                        orderController.status.value = _selectedOption;
                        orderController.getOrders();
                        print(orderController.orders.value);
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
                              baseColor:borderColor,
                              highlightColor: borderColor,
                              child: Container(
                                height: 160,
                                width: 100,
                                color:borderColor,
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
                      return orderController.orders.length==0?Text('not',style: TextStyle(color: Colors.black),): buildOrder(orderController.orders[index]);
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
        border: Border.all(color:  const Color(0xffeef2fa), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${Translator.translate('Order Id :')}'+'${model.id}',
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),

              Text(
                langCode=='ar'?'${model.statu!.title!.ar}':'${model.statu!.title!.en}',
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
                    Translator.translate('Total price :')+
                        '${model.total!}',
                  ),
                ],
              ),

            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Translator.translate('Order Date:')+'${model.orderTime!.orderDate.toString()}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                letterSpacing: 0),

          ),
          const SizedBox(height: 10,),
          Text(
            Translator.translate('Order Time:') + '${model.orderTime!.orderTimeFrom}-${model.orderTime!.orderTimeTo}',
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
                        orderController.changeStatus(model.id, 'accepted');
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
                        orderController.changeStatus(model.id, 'rejected');
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
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
                        text: Translator.translate("order already delivered"),
                        state: toastStates.ERROR);
                    // orderController.changeStatus(model.id, 'delivered');
                  },
                  child: Text(Translator.translate('delivered done'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
                          color: Colors.white, fontWeight: FontWeight.bold)),
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
