import 'dart:async';
import 'dart:developer';

import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/api/currency_api.dart';
import 'package:DeliveryBoyApp/controllers/AuthController.dart';
import 'package:DeliveryBoyApp/controllers/OrderController.dart';
import 'package:DeliveryBoyApp/models/AllOrdersModel.dart';
import 'package:DeliveryBoyApp/models/DeliveryBoy.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';

import 'package:DeliveryBoyApp/models/Product.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/services/firestore_services.dart';
import 'package:DeliveryBoyApp/utils/ColorUtils.dart';
import 'package:DeliveryBoyApp/utils/Generator.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/views/LoadingScreens.dart';
import 'package:DeliveryBoyApp/views/auth/SettingScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../AppTheme.dart';
import '../AppThemeNotifier.dart';
import 'SingleOrderScreen.dart';



class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with WidgetsBindingObserver {
  //ThemeData
  ThemeData? themeData;
  CustomAppTheme? customAppTheme;

  late FirestoreServices firestoreServices;

  //Global Key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = new GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  //Other Variables
  bool isInProgress = false;
  AllOrders? orders ;
  DeliveryBoy? deliveryBoy;

  bool isLoading=false;
  Position? currentLocation;

  initState() {
    firestoreServices = FirestoreServices();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _initUserData();
    _loadOrderData();
    determinePosition();
    //  getCurrentLocation();
  }
  _initUserData() async {
    DeliveryBoy user = await AuthController.getUser();
    setState(() {
      deliveryBoy = user;
    });

    if(deliveryBoy!=null){
      deliveryBoy = await firestoreServices.checkOrdersIsExistsAndCreate(deliveryBoy!);
      startLocationUpdate();
    }




  }

  getToken()async{

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await _firebaseMessaging.getToken();
    log(fcmToken.toString());
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // Future<Position> getCurrentLocation() async {
  //   // Request permission to access the device's location
  //   final PermissionStatus permissionStatus = await Permission.locationAlways.request();

  //   // If permission is granted, get the current location
  //   if (permissionStatus == PermissionStatus.granted) {
  //     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //   }

  //   // If permission is not granted, throw an exception or return null
  //   // depending on your use case
  //   else {
  //     throw Exception('Permission not granted');
  //   }
  // }

  Future<void> _refresh() async {
    if (!isInProgress) _loadOrderData();
  }



  // void updateDriverLocation(String driverId, Position location) {
  //   final databaseReference = FirebaseDatabase.instance.reference();
  //   databaseReference.child('drivers/$driverId/location').set({
  //     'latitude': location.latitude,
  //     'longitude': location.longitude,
  //   });
  // }

  void startLocationUpdate() {
    Timer.periodic(Duration(seconds: 7), (timer) async {
      // Get the current location of the driver
      Position location = await determinePosition();

      currentLocation=location;

      // Update the driver's location in Firebase
      firestoreServices.updateLatLong(deliveryBoy!,  lat: location.latitude,long:location.longitude);
      log("updated Position");
    });
  }

  _loadOrderData() async {
    setState(() {
      isInProgress = true;
    });
    MyResponse<AllOrders> myResponse = await OrderController.getAllOrder();
    if (myResponse.success) {
      orders = myResponse.data;
    } else {
      ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      showMessage(message: myResponse.errorText);
    }

    setState(() {
      isInProgress = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.detached) {}
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  Widget build(BuildContext context) {

    getToken();

    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeMode = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeMode);
        customAppTheme = AppTheme.getCustomAppTheme(themeMode);
        return MaterialApp(
          scaffoldMessengerKey: _scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
          home: Scaffold(
              backgroundColor: customAppTheme!.bgLayer2,
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: customAppTheme!.bgLayer2,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  Translator.translate("orders"),
                  style: AppTheme.getTextStyle(themeData!.textTheme.headline6,
                      color: themeData!.colorScheme.onBackground,
                      fontWeight: 600),
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()));
                    },
                    child: Container(
                      margin: Spacing.right(20),
                      child: Icon(
                        MdiIcons.cogOutline,
                        size: MySize.size20,
                        color: themeData!.colorScheme.onBackground,
                      ),
                    ),
                  )
                ],
              ),
              body: RefreshIndicator(
                onRefresh: _refresh,
                backgroundColor: customAppTheme!.bgLayer1,
                color: themeData!.colorScheme.primary,
                key: _refreshIndicatorKey,
                child: Column(
                  children: [
                    Container(
                      height: MySize.size3,
                      child: isInProgress
                          ? LinearProgressIndicator(
                        minHeight: MySize.size3,
                      )
                          : Container(
                        height: MySize.size3,
                      ),
                    ),
                    isLoading ?   Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height *0.7,child: Center(child: CircularProgressIndicator(),),)  :   Expanded(
                      child: _buildBody(),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  _buildBody() {

    if ( orders!=null && (orders!.currentOrders.length != 0  || orders!.pendingOrders.length != 0 || orders!.lastOrders.length != 0) ) {
      return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingScreen()));
          }
        },
        child: ListView(
          padding: Spacing.zero,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
              child: Container(
                padding: Spacing.all(16),
                margin: Spacing.fromLTRB(16, 16, 16, 8),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
                  color: customAppTheme!.bgLayer1,
                  border: Border.all(color: customAppTheme!.bgLayer3, width: 1.5),
                ),
                child: Column(
                  children: [

                    Center(

                      child: Text(
                        Translator.translate("Admin_Revenue") + " : " +      " " +
                            CurrencyApi.getSign(afterSpace: true) +
                            CurrencyApi.doubleToString(orders!.adminRevenue.toDouble()) +
                            " " ,
                        style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                            color: themeData!.colorScheme.onBackground,
                            fontWeight: 800,
                            fontSize: MySize.size14,
                            muted: true),
                      ),
                    ),

                    SizedBox(height: 20,),

                    Center(

                      child: Text(
                        Translator.translate("Shop_Revenue") + " : " +     " " +
                            CurrencyApi.getSign(afterSpace: true) +
                            CurrencyApi.doubleToString(orders!.shopRevenue.toDouble()) +
                            " " ,
                        style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                            color: themeData!.colorScheme.onBackground,
                            fontWeight: 800,
                            fontSize: MySize.size14,
                            muted: true),
                      ),
                    ),
                    SizedBox(height: 20,),

                    Center(

                      child: Text(
                        Translator.translate("delivery_rev") + " : " +      " " +
                            CurrencyApi.getSign(afterSpace: true) +
                            CurrencyApi.doubleToString(orders!.deliveryRevenue.toDouble()) +
                            " " ,
                        style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                            color: themeData!.colorScheme.onBackground,

                            fontWeight: 800,
                            fontSize: MySize.size14,
                            muted: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),




            Container(
              margin: Spacing.fromLTRB(16, 16, 16, 8),
              child: Text(
                Translator.translate("active").toUpperCase(),
                style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                    color: themeData!.colorScheme.onBackground,
                    fontWeight: 700,
                    muted: true),
              ),
            ),
            _getActiveOrderView(orders!.currentOrders!),

            Container(
              margin: Spacing.fromLTRB(16, 8, 16, 8),
              child: Text(
                Translator.translate("pending"),
                style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                    color: themeData!.colorScheme.onBackground,
                    fontWeight: 700,
                    muted: true),
              ),
            ),

            _getPendingOrderView(orders!.pendingOrders!),

            Container(
              margin: Spacing.fromLTRB(16, 8, 16, 8),
              child: Text(
                Translator.translate("past").toUpperCase(),
                style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                    color: themeData!.colorScheme.onBackground,
                    fontWeight: 700,
                    muted: true),
              ),
            ),
            _getPastOrderView(orders!.lastOrders!),
          ],
        ),
      );
    } else if (isInProgress) {
      return LoadingScreens.getOrderLoadingScreen(
          context, themeData!, customAppTheme!);
    } else {
      return ListView(
        padding: Spacing.top(60),
        children: [
          Center(
              child: Text(
                Translator.translate("there_is_no_order_yet"),
                style: AppTheme.getTextStyle(themeData!.textTheme.bodyText2,
                    color: themeData!.colorScheme.onBackground, fontWeight: 600),
              ))
        ],
      );
    }
  }

  _getActiveOrderView( orders) {
   return SizedBox(width: 500,height: 300,
    child: ListView.builder(
      itemCount: orders.length,
      itemBuilder:
    (context, index) {
      if (AllOrders.checkIsActiveOrder(orders[index].status)) {
            return Container(
                margin: Spacing.horizontal(16),
                child: _singleOrderItem(order: orders[index], activeOrder: true));
    }},)
      ,);
    // for (int i = 0; i < orders.length; i++) {
    //   if (AllOrders.checkIsActiveOrder(orders[i].status)) {
    //     return Container(
    //         margin: Spacing.horizontal(16),
    //         child: _singleOrderItem(order: orders[i], activeOrder: true));
    //   }
    // }
    return Container(
      margin: Spacing.all(16),
      child: Center(
          child: Text(Translator.translate("there_is_no_any_active_order"))),
    );
  }

  _getPastOrderView( orders) {
    List<Widget> listViews = [];
    for (int i = 0; i < orders.length; i++) {
      if (!AllOrders.checkIsActiveOrder(orders[i].status)) {
        listViews.add(InkWell(
          onTap: () async {
            if (AllOrders.checkStatusDelivered(orders[i].status)) {
            } else if (AllOrders.checkStatusReviewed(orders[i].status)) {
            } else {}
          },
          child: _singleOrderItem(order: orders[i]),
        ));
      }
    }

    if (listViews.length > 0) {
      return Container(
        margin: Spacing.horizontal(16),
        child: Column(
          children: listViews,
        ),
      );
    } else {
      return Container(
        child: Center(
            child: Text(Translator.translate("there_is_no_any_past_order"))),
      );
    }
  }


  bool isDateAfterOrEqual(DateTime scheduled, DateTime now) {

print('scheduled');
print(scheduled);
print(DateTime);
    return scheduled.isAfter(now) || scheduled.isAtSameMomentAs(now);//false
  }

  _getPendingOrderView( orders) {
    List<Widget> listViews = [];
    for (int i = 0; i < orders.length; i++) {
      if (!AllOrders.checkIsActiveOrder(orders[i].status) ) {
        dynamic scheduleDate=null;

        if(orders[i].orderTime!=null){
          scheduleDate = DateFormat('dd-MM-yyyy - HH:mm').parse(orders[i].orderTime["order_date"] + " - " + orders[i].orderTime["order_time"]);
        }

        if(orders[i].orderTime == null || isDateAfterOrEqual(DateTime.now(),scheduleDate ,)){


          listViews.add(InkWell(
            onTap: () async {
              if (AllOrders.checkStatusDelivered(orders[i].status)) {
              } else if (AllOrders.checkStatusReviewed(orders[i].status)) {
              } else {

              }
            },
            child: _singlePendingOrderItem(order: orders[i]),
          ));
        }
      }
    }

    if (listViews.length > 0) {
      return Container(
        margin: Spacing.horizontal(16),
        child: Column(
          children: listViews,
        ),
      );
    } else {
      return Container(
        child: Center(
            child: Text(Translator.translate("there_is_no_any_pending_order"))),
      );
    }
  }


  _singlePendingOrderItem({required  order, activeOrder = false}) {
    double space = MySize.size16!;
    double width =
        (MySize.screenWidth - MySize.getScaledSizeHeight(83) - (2 * space)) / 3;

    List<Widget> _itemWidget = [];
    for (int i = 0; i < order.carts.length; i++) {
      if (i == 2 && order.carts.length > 3) {
        _itemWidget.add(
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
            child: Container(
              color: customAppTheme!.bgLayer3,
              height: width,
              width: width,
              child: Center(
                  child: Text(
                    "+" + (order.carts.length - 2).toString(),
                    style: AppTheme.getTextStyle(themeData!.textTheme.subtitle1,
                        letterSpacing: 0.5,
                        color: themeData!.colorScheme.onBackground,
                        fontWeight: 600),
                  )),
            ),
          ),
        );
        break;
      } else {
        _itemWidget.add(Container(
          margin: (i == 2) ? EdgeInsets.zero : EdgeInsets.only(right: space),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
              child: order.carts[i].product!.productImages!.length != 0
                  ? Image.network(
                order.carts[i].product!.productImages![0].url!,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return LoadingScreens.getSimpleImageScreen(
                        context, themeData, customAppTheme!,
                        width: MySize.size90, height: MySize.size90);
                  }
                },
                height: width,
                width: width,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                Product.getPlaceholderImage(),
                height: MySize.size90,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ));
      }
    }

    return InkWell(
      onTap: () async {
        if (activeOrder) {
          LocationPermission? locationPermission = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SingleOrderScreen(
                order: order,

              ),
            ),
          );
          _refresh();
          if (locationPermission != null) {
            if (locationPermission == LocationPermission.denied) {
              showMessage(
                  message:
                  Translator.translate("please_give_location_permission"));
            } else if (locationPermission == LocationPermission.deniedForever) {
              Geolocator.openAppSettings();
              showMessage(
                  message: Translator.translate(
                      "please_give_location_permission_in_setting"));
            }
          } else {}
        }
      },
      child: Container(
        padding: Spacing.all(16),
        margin: Spacing.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
          color: customAppTheme!.bgLayer1,
          border: Border.all(color: customAppTheme!.bgLayer3, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translator.translate("order") +
                            " " +
                            order.id.toString(),
                        style: AppTheme.getTextStyle(
                            themeData!.textTheme.subtitle1,
                            fontWeight: 700,
                            letterSpacing: -0.2),
                      ),
                      Container(
                        margin: Spacing.only(top: 4),
                        child: Text(
                          CurrencyApi.getSign(afterSpace: true) + CurrencyApi.doubleToString(order.total),
                          style: AppTheme.getTextStyle(
                              themeData!.textTheme.bodyText2,
                              fontWeight: 600,
                              letterSpacing: 0),
                        ),
                      ),



                      Container(
                        margin: Spacing.only(top: 4),
                        child: Text(
                          Translator.translate("admin_will_take") +" " + CurrencyApi.getSign(afterSpace: true) + CurrencyApi.doubleToString(order.total-order.deliveryFee.toDouble()),
                          style: AppTheme.getTextStyle(
                              themeData!.textTheme.bodyText2,
                              fontWeight: 600,
                              letterSpacing: 0),
                        ),)
                    ],
                  ),
                ),
                Container(
                  padding: Spacing.fromLTRB(12, 8, 12, 8),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(MySize.size4)),
                      color: customAppTheme!.bgLayer3),
                  child: Text(
                    AllOrders.getTextFromOrderStatus(order.status).toUpperCase(),
                    style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                        fontSize: 11, fontWeight: 700, letterSpacing: 0.25),
                  ),
                )
              ],
            ),
            // Container(
            //     margin: Spacing.only(top: 16),
            //     child: Text(
            //         Generator.convertDateTimeToText(order.createdAt,
            //             showSecond: false),
            //         style: AppTheme.getTextStyle(themeData!.textTheme.caption,
            //             fontWeight: 600,
            //             letterSpacing: -0.1,
            //             color: themeData!.colorScheme.onBackground
            //                 .withAlpha(160))),),
            Container(
              margin: Spacing.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _itemWidget,
              ),
            ),
            order.deliveryBoyReview != null
                ? Container(
              margin:Spacing.top(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: Spacing.fromLTRB(0,8,0,8),
                    child: Row(
                      children: [
                        Generator.buildRatingStar(
                            activeColor: ColorUtils.getColorFromRating(
                                order.deliveryBoyReview!.rating,
                                customAppTheme,
                                themeData),
                            inactiveColor: themeData!
                                .colorScheme.onBackground
                                .withAlpha(60),
                            rating:
                            order.deliveryBoyReview!.rating!.toDouble(),
                            spacing: 0,
                            inactiveStarFilled: true),
                        Container(
                          margin: Spacing.left(8),
                          child: Text(
                            Generator.convertDateTimeToText(
                                order.deliveryBoyReview!.createdAt!,
                                showDate: true,
                                showTime: false),
                            style: AppTheme.getTextStyle(
                                themeData!.textTheme.caption,
                                fontSize: 12,
                                fontWeight: 600,
                                xMuted: true),
                          ),
                        )
                      ],
                    ),
                  ),
                  order.deliveryBoyReview!.review!=null ? Container(

                    child: Text(
                      order.deliveryBoyReview!.review!,
                      style: AppTheme.getTextStyle(
                          themeData!.textTheme.caption,
                          color: themeData!.colorScheme.onBackground,
                          fontWeight: 500),
                    ),
                  ):Container(),
                ],
              ),
            )
                : Container(),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                Translator.translate("you_earned") +
                    " " +
                    CurrencyApi.getSign(afterSpace: true) +
                    CurrencyApi.doubleToString(order.deliveryFee.toDouble()) +
                    " " +
                    Translator.translate("from_this_order"),
                style: AppTheme.getTextStyle(themeData!.textTheme.bodyText2,
                    color: themeData!.colorScheme.onBackground, fontWeight: 600),
              ),
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {

                    isLoading=true;
                    setState(() {

                    });
                    OrderController.acceptRefuseOrder(order.id,status: 4).then((value) {
                      isLoading=false;
                      _refresh();
                      setState(() {

                      });
                    });
                  },
                  child:Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.withOpacity(0.2)),
                      child: Center(child: Text(Translator.translate("Accept"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),))) ,
                ),
                InkWell(
                  onTap: () {
                    isLoading=true;
                    setState(() {

                    });
                    OrderController.acceptRefuseOrder(order.id,status: -2).then((value) {
                      isLoading=false;
                      setState(() {

                      });
                      _refresh();

                    });
                  },
                  child:Text(Translator.translate("Decline"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),) ,
                ),
                InkWell(
                  onTap: () {
                    // log(order.status.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SingleOrderScreen(
                          order: order,


                        ),
                      ),
                    );
                  },
                  child:Text(Translator.translate("view"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),) ,
                ),
              ],)
          ],
        ),
      ),
    );
  }
  _singleOrderItem({required  order, activeOrder = false}) {
    double space = MySize.size16!;
    double width =
        (MySize.screenWidth - MySize.getScaledSizeHeight(83) - (2 * space)) / 3;

    List<Widget> _itemWidget = [];
    for (int i = 0; i < order.carts.length; i++) {
      if (i == 2 && order.carts.length > 3) {
        _itemWidget.add(
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
            child: Container(
              color: customAppTheme!.bgLayer3,
              height: width,
              width: width,
              child: Center(
                  child: Text(
                    "+" + (order.carts.length - 2).toString(),
                    style: AppTheme.getTextStyle(themeData!.textTheme.subtitle1,
                        letterSpacing: 0.5,
                        color: themeData!.colorScheme.onBackground,
                        fontWeight: 600),
                  )),
            ),
          ),
        );
        break;
      } else {
        _itemWidget.add(Container(
          margin: (i == 2) ? EdgeInsets.zero : EdgeInsets.only(right: space),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
              child: order.carts[i].product!.productImages!.length != 0
                  ? Image.network(
                order.carts[i].product!.productImages![0].url!,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return LoadingScreens.getSimpleImageScreen(
                        context, themeData, customAppTheme!,
                        width: MySize.size90, height: MySize.size90);
                  }
                },
                height: width,
                width: width,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                Product.getPlaceholderImage(),
                height: MySize.size90,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ));
      }
    }

    return InkWell(
      onTap: () async {
        if (activeOrder) {
          LocationPermission? locationPermission = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SingleOrderScreen(
                order: order,


              ),
            ),
          );
          _refresh();
          if (locationPermission != null) {
            if (locationPermission == LocationPermission.denied) {
              showMessage(
                  message:
                  Translator.translate("please_give_location_permission"));
            } else if (locationPermission == LocationPermission.deniedForever) {
              Geolocator.openAppSettings();
              showMessage(
                  message: Translator.translate(
                      "please_give_location_permission_in_setting"));
            }
          } else {}
        }
      },
      child: Container(
        padding: Spacing.all(16),
        margin: Spacing.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
          color: customAppTheme!.bgLayer1,
          border: Border.all(color: customAppTheme!.bgLayer3, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translator.translate("order") +
                            " " +
                            order.id.toString(),
                        style: AppTheme.getTextStyle(
                            themeData!.textTheme.subtitle1,
                            fontWeight: 700,
                            letterSpacing: -0.2),
                      ),
                      Container(
                        margin: Spacing.only(top: 4),
                        child: Text(
                          CurrencyApi.getSign(afterSpace: true) + CurrencyApi.doubleToString(order.total),
                          style: AppTheme.getTextStyle(
                              themeData!.textTheme.bodyText2,
                              fontWeight: 600,
                              letterSpacing: 0),
                        ),
                      ),

                      Container(
                        margin: Spacing.only(top: 4),
                        child: Text(
                          Translator.translate("admin_will_take") +" " + CurrencyApi.getSign(afterSpace: true) + CurrencyApi.doubleToString(order.total-order.deliveryFee.toDouble()),
                          style: AppTheme.getTextStyle(
                              themeData!.textTheme.bodyText2,
                              fontWeight: 600,
                              letterSpacing: 0),
                        ),)
                    ],
                  ),
                ),
                Container(
                  padding: Spacing.fromLTRB(12, 8, 12, 8),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(MySize.size4)),
                      color: customAppTheme!.bgLayer3),
                  child: Text(
                    AllOrders.getTextFromOrderStatus(order.status).toUpperCase(),
                    style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                        fontSize: 11, fontWeight: 700, letterSpacing: 0.25),
                  ),
                )
              ],
            ),
            // Container(
            //     margin: Spacing.only(top: 16),
            //     child: Text(
            //         Generator.convertDateTimeToText(order.createdAt,
            //             showSecond: false),
            //         style: AppTheme.getTextStyle(themeData!.textTheme.caption,
            //             fontWeight: 600,
            //             letterSpacing: -0.1,
            //             color: themeData!.colorScheme.onBackground
            //                 .withAlpha(160))),),
            Container(
              margin: Spacing.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _itemWidget,
              ),
            ),
            order.deliveryBoyReview != null
                ? Container(
              margin:Spacing.top(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: Spacing.fromLTRB(0,8,0,8),
                    child: Row(
                      children: [
                        Generator.buildRatingStar(
                            activeColor: ColorUtils.getColorFromRating(
                                order.deliveryBoyReview!.rating,
                                customAppTheme,
                                themeData),
                            inactiveColor: themeData!
                                .colorScheme.onBackground
                                .withAlpha(60),
                            rating:
                            order.deliveryBoyReview!.rating!.toDouble(),
                            spacing: 0,
                            inactiveStarFilled: true),
                        Container(
                          margin: Spacing.left(8),
                          child: Text(
                            Generator.convertDateTimeToText(
                                order.deliveryBoyReview!.createdAt!,
                                showDate: true,
                                showTime: false),
                            style: AppTheme.getTextStyle(
                                themeData!.textTheme.caption,
                                fontSize: 12,
                                fontWeight: 600,
                                xMuted: true),
                          ),
                        )
                      ],
                    ),
                  ),
                  order.deliveryBoyReview!.review!=null ? Container(

                    child: Text(
                      order.deliveryBoyReview!.review!,
                      style: AppTheme.getTextStyle(
                          themeData!.textTheme.caption,
                          color: themeData!.colorScheme.onBackground,
                          fontWeight: 500),
                    ),
                  ):Container(),
                ],
              ),
            )
                : Container(),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                Translator.translate("you_earned") +
                    " " +
                    CurrencyApi.getSign(afterSpace: true) +
                    CurrencyApi.doubleToString(order.deliveryFee.toDouble()) +
                    " " +
                    Translator.translate("from_this_order"),
                style: AppTheme.getTextStyle(themeData!.textTheme.bodyText2,
                    color: themeData!.colorScheme.onBackground, fontWeight: 600),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showMessage({String message = "Something wrong", Duration? duration}) {
    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(message,
            style: AppTheme.getTextStyle(themeData!.textTheme.subtitle2,
                letterSpacing: 0.4, color: themeData!.colorScheme.onPrimary)),
        backgroundColor: themeData!.colorScheme.primary,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}

