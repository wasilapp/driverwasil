import 'dart:developer';

import 'package:DeliveryBoyApp/models/DeliveryBoy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('drivers');

  Future<DeliveryBoy> checkOrdersIsExistsAndCreate(
      DeliveryBoy deliveryBoy) async {
    log("checking");

    try {
      var ds = await collection.where("id", isEqualTo: deliveryBoy.id).get();

      if (ds.docs.isEmpty) {
        log("empty");
        addDelivery(deliveryBoy);
        return deliveryBoy;
      } else {
        return deliveryBoy
            .fromMap(ds.docs.first.data() as Map<String, dynamic>);
      }
    } catch (e) {}
    return deliveryBoy;
  }

  Future<DocumentReference> addDelivery(DeliveryBoy deliveryBoy,
      {double lat = 0.0, double long = 0.0}) {
    return collection.add(deliveryBoy.toMap());
  }

  updateLatLong(DeliveryBoy deliveryBoy,
      {double lat = 0.0, double long = 0.0}) async {
    var ds = await collection.where("id", isEqualTo: deliveryBoy.id).get();
    await collection.doc(ds.docs.first.id).update({
      "lat": lat,
      "long": long,
    });
  }

  updateIsOffline(DeliveryBoy deliveryBoy, bool isOffline) async {
    var ds = await collection.where("id", isEqualTo: deliveryBoy.id).get();
    await collection.doc(ds.docs.first.id).update({
      "isOffline": isOffline,
    });
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ordertracking/core/networking/constants.dart';
// import 'package:ordertracking/models/order_model_firebase.dart';
// import 'package:ordertracking/models/orders_model.dart';

// class FirebaseRepo {
//   // 1
//   final CollectionReference collection =
//       FirebaseFirestore.instance.collection('orders');
//   // 2
//   Stream<QuerySnapshot>? getStream() {

//     try{
//        return collection.snapshots();
//     }catch(e){
//       print("i am in error");
//       print(e.toString());

//     }

//    return null;
//   }

//     Stream<QuerySnapshot> getStreamForDriver(driverId) {
//     return collection.where("driver_id",isEqualTo: driverId).snapshots();
//   }

//    sendLongAndLatitudeToFirebase(OrderModel order,String latitude,String longitude)async {

//        var ds = await collection.where("id" ,isEqualTo: order.id).where("tracking_number",isEqualTo: order.trackingNumber).get();
//         await collection.doc(ds.docs.first.id).update({
//             "driver_latitude" : latitude,
//             "driver_longitude":longitude,
//         });

//     print("supposed done");
//     //return collection.add(order.toMap());
//   }

//      changeFirebaseOrderStatus(OrderModel order,int active,int status)async {

//        var ds = await collection.where("id" ,isEqualTo: order.id).where("tracking_number",isEqualTo: order.trackingNumber).get();
//         await collection.doc(ds.docs.first.id).update({
//             "active" : active,
//             "status":status,
//         });

//     print("supposed done");
//     //return collection.add(order.toMap());
//   }

//     Future<OrderModelFirebase> checkOrdersIsExistsAndCreate(OrderModel order)async {

//        var ds = await collection.where("id" ,isEqualTo: order.id).where("tracking_number",isEqualTo: order.trackingNumber).get();

//        if(ds.docs.isEmpty){
//          OrderModelFirebase orderModelFirebase= OrderModelFirebase(active: 0,id: order.id,driverId: order.driverId,
//          mobile: order.mobile,latitude: order.latitude,longitude: order.longitude,
//          driverLat: "0.00",driverLon: "0.00",status: order.status,
//          trackingNumber: order.trackingNumber,
//          createdAt: order.createdAt,
//          updatedAt: order.updatedAt,
//          driverName: Constants.user!.name,
//          driverPhone: Constants.user!.phone,
//          driverImage: Constants.user!.image,
//          carNumber: Constants.user!.carNumber,
//          );
//          addOrder(orderModelFirebase);

//          return orderModelFirebase;
//        }else{
//           return OrderModelFirebase.fromMap(  ds.docs.first.data() as Map<String, dynamic>);
//        }
//     print(ds.docs.first.data());
//     //return collection.add(order.toMap());
//   }

//     Future<OrderModelFirebase?> checkTrackingNumberExists(String trackingNumber)async {

//        var ds = await collection.where("tracking_number",isEqualTo: trackingNumber).get();

//        if(ds.docs.isEmpty){
//          return null;
//        }else{
//           return OrderModelFirebase.fromMap(  ds.docs.first.data() as Map<String, dynamic>);
//        }

//     //return collection.add(order.toMap());
//   }

//   // 3
//   Future<DocumentReference> addOrder(OrderModelFirebase order) {

//     return collection.add(order.toMap());
//   }
//   // 4
//   void updateOrder(OrderModelFirebase order) async {
//     await collection.doc(order.trackingNumber).update(order.toMap());
//   }
//   // 5
//   void deleteOrder(OrderModelFirebase order) async {
//     await collection.doc(order.trackingNumber).delete();
//   }
// }
