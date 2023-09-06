


// To parse this JSON data, do
//
//     final allOrders = allOrdersFromJson(jsonString);

import 'dart:convert';

import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:flutter/material.dart';



AllOrders allOrdersFromJson(String str) => AllOrders.fromJson(json.decode(str));

String allOrdersToJson(AllOrders data) => json.encode(data.toJson());

class AllOrders {
    AllOrders({
        required this.lastOrders,
        required this.currentOrders,
        required this.pendingOrders,
        required this.shopRevenue,
        required this.adminRevenue,
        required this.deliveryRevenue
    });

    List<LastOrder> lastOrders;
    List<Order> currentOrders;
    List<Order> pendingOrders;
    double adminRevenue;
    double shopRevenue;
    double deliveryRevenue;

    factory AllOrders.fromJson(Map<String, dynamic> json) => AllOrders(
        lastOrders: List<LastOrder>.from(json["last_orders"].map((x) => LastOrder.fromJson(x))),
        currentOrders: List<Order>.from(json["current_orders"].map((x) => Order.fromJson(x))),
        pendingOrders: List<Order>.from(json["pending_orders"].map((x) => Order.fromJson(x))),
        adminRevenue: json["admin_rev"].toDouble() ?? 0.0,
        shopRevenue:  json["shop_rev"].toDouble() ?? 0.0,
        deliveryRevenue: json["delivery_rev"].toDouble() ?? 0.0,
    );

    Map<String, dynamic> toJson() => {
        "last_orders": List<dynamic>.from(lastOrders.map((x) => x.toJson())),
        "current_orders": List<dynamic>.from(currentOrders.map((x) => x.toJson())),
        "pending_orders": List<dynamic>.from(pendingOrders.map((x) => x.toJson())),
    };

           static bool checkStatusDelivered(dynamic status){
    return status==5;

  }

  static bool checkStatusReviewed(dynamic status){
    return status==6;
  }

  static bool checkIsActiveOrder(dynamic status){
    return status>2 && status<5;
  }


  static String getPaymentTypeText(dynamic paymentType){
    switch(paymentType){
      case 1:
        return Translator.translate("cash_on_delivery");
      case 2:
        return "Razorpay";
      case 3:
        return "Paystack";
      case 4:
        return "Stripe";
      case 5:
        return Translator.translate("wallet");

    }
    return getPaymentTypeText(1);
  }


  static dynamic getDiscountFromCoupon(dynamic originalOrderPrice, dynamic offer){
    return originalOrderPrice*offer/100;
  }

  static String convertCurrencyToString(dynamic num){
    return num.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }

    static String getTextFromOrderStatus(dynamic status){
    switch(status){
      case 1:
        return Translator.translate("wait_for_confirmation");
      case 2:
        return Translator.translate("accepted");
      case 3:
        return Translator.translate("pick_up_order_from_shop");
      case 4:
        return Translator.translate("on_the_way");
      case 5:
        return  Translator.translate("delivered"); 
      case 6:
        return Translator.translate("Reviewed"); 
      default:
        return getTextFromOrderStatus(1);
    }
  }

  static Color getColorFromOrderStatus(dynamic status){
    switch(status){
      case 1:
        return Color.fromRGBO(255, 170, 85,1.0);
      case 2:
        return Color.fromRGBO(90, 149, 154,1.0);
      case 3:
        return Color.fromRGBO(255, 170, 85,1.0);
      case 4:
        return Color.fromRGBO(34,187,51,1.0);
      case 5:
        return Color.fromRGBO(34,187,51,1.0);
      default:
        return getColorFromOrderStatus(1);
    }
  }
}

class Order {
    Order({
        required this.id,
        required this.status,
        required this.orderType,
        required this.order,
        required this.shopRevenue,
        required this.adminRevenue,
        required this.deliveryFee,
        required this.total,
        required this.otp,
        this.couponDiscount,
        required this.latitude,
        required this.longitude,
        this.couponId,
        required this.deliveryBoyId,
        required this.userId,
        required this.addressId,
        required this.shopId,
        required this.orderPaymentId,
        required this.count,
        required this.type,
        required this.createdAt,
        required this.updatedAt,
        required this.carts,
        required this.shop,
        this.deliveryBoyReview,
        required this.orderPayment,
        this.orderTime,
       required   this.userOrder,
       required   this.addresOrder,


    });

    dynamic id;
    dynamic status;
    dynamic orderType;
    dynamic order;
    dynamic shopRevenue;
    dynamic adminRevenue;
    dynamic deliveryFee;
    dynamic total;
    dynamic otp;
    dynamic couponDiscount;
    dynamic latitude;
    dynamic longitude;
    dynamic couponId;
    dynamic deliveryBoyId;
    dynamic userId;
    dynamic addressId;
    dynamic shopId;
    dynamic orderPaymentId;
    dynamic count;
    dynamic type;
    String createdAt;
    String updatedAt;
    List<dynamic> carts;
    Shop? shop;
    User ?userOrder;
    Address?addresOrder;
     DeliveryBoyReview? deliveryBoyReview;
     OrderPayment orderPayment;
     dynamic orderTime;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        status: json["status"],
        orderType: json["order_type"],
        order: json["order"]?.toDouble(),
        shopRevenue: json["shop_revenue"]?.toDouble(),
        adminRevenue: json["admin_revenue"]?.toDouble(),
        deliveryFee: json["delivery_fee"]?.toDouble(),
        total: json["total"]?.toDouble(),
        otp: json["otp"],
        couponDiscount: json["coupon_discount"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        couponId: json["coupon_id"],
        deliveryBoyId: json["delivery_boy_id"],
        userId: json["user_id"],
        addressId: json["address_id"],
        shopId: json["shop_id"],
        orderPaymentId: json["order_payment_id"],
        count: json["count"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        carts: List<dynamic>.from(json["carts"].map((x) => x)),
        shop: json["shop"]!=null ?     Shop.fromJson(json["shop"]):null,
        userOrder: json["user"]!=null ?     User.fromJson(json["user"]):null,
        addresOrder: json["user_address"]!=null ?     Address.fromJson(json["user_address"]):null,
       deliveryBoyReview: json["delivery_boy_review"] == null ? null : DeliveryBoyReview.fromJson(json["delivery_boy_review"]),
        orderPayment: OrderPayment.fromJson(json["order_payment"]),
        orderTime: json["order_time"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "order_type": orderType,
        "order": order,
        "shop_revenue": shopRevenue,
        "admin_revenue": adminRevenue,
        "delivery_fee": deliveryFee,
        "total": total,
        "otp": otp,
        "coupon_discount": couponDiscount,
        "latitude": latitude,
        "longitude": longitude,
        "coupon_id": couponId,
        "delivery_boy_id": deliveryBoyId,
        "user_id": userId,
        "address_id": addressId,
        "shop_id": shopId,
        "order_payment_id": orderPaymentId,
        "count": count,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "carts": List<dynamic>.from(carts.map((x) => x)),
        "shop": shop !=null ? shop!.toJson():null,
        "user": userOrder !=null ? userOrder!.toJson():null,
        "user_address":        addresOrder !=null ? addresOrder!.toJson():null,

        "delivery_boy_review": deliveryBoyReview,
        "order_payment": orderPayment.toJson(),
    };
}

class Address{
    Address({
        required this.id,required this.latitude, required this.longitude,
    });

    dynamic id;
     String latitude;
    String longitude;


    factory Address.fromJson(Map<String, dynamic> json) => Address(

        id: json["id"],
        latitude: json["latitude"],
        longitude: json["longitude"],


    );

    Map<String, dynamic> toJson() => {

        "id": id,
        "latitude": latitude,
        "longitude": longitude,


    };
}

class Shop {
    Shop({
        required this.id,
        required this.name,
        required this.email,
        required this.mobile,
        required this.barcode,
        required this.latitude,
        required this.longitude,
        required this.address,
        required this.imageUrl,
        required this.rating,
        required this.deliveryRange,
        required this.totalRating,
        required this.defaultTax,
        required this.availableForDelivery,
        required this.open,
        required this.managerId,
        required this.categoryId,
        required this.createdAt,
        required this.updatedAt,
    });

    dynamic id;
    String name;
    String email;
    String mobile;
    String barcode;
    dynamic latitude;
    dynamic longitude;
    String address;
    String imageUrl;
    dynamic rating;
    dynamic deliveryRange;
    dynamic totalRating;
    dynamic defaultTax;
    dynamic availableForDelivery;
    dynamic open;
    dynamic managerId;
    dynamic categoryId;
    String createdAt;
    String updatedAt;

    factory Shop.fromJson(Map<String, dynamic> json) => Shop(

        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        barcode: json["barcode"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        imageUrl: json["image_url"],
        rating: json["rating"]?.toDouble(),
        deliveryRange: json["delivery_range"]?.toDouble(),
        totalRating: json["total_rating"]?.toDouble(),
        defaultTax: json["default_tax"]?.toDouble(),
        availableForDelivery: json["available_for_delivery"],
        open: json["open"],
        managerId: json["manager_id"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
    
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "barcode": barcode,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "image_url": imageUrl,
        "rating": rating,
        "delivery_range": deliveryRange,
        "total_rating": totalRating,
        "default_tax": defaultTax,
        "available_for_delivery": availableForDelivery,
        "open": open,
        "manager_id": managerId,
        "category_id": categoryId,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
class OrderPayment {
    OrderPayment({
        required this.id,
        required this.paymentType,
        required this.success,
        this.paymentId,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    int paymentType;
    int success;
    dynamic paymentId;
    String createdAt;
    String updatedAt;

    factory OrderPayment.fromJson(Map<String, dynamic> json) => OrderPayment(
        id: json["id"],
        paymentType: json["payment_type"],
        success: json["success"],
        paymentId: json["payment_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "payment_type": paymentType,
        "success": success,
        "payment_id": paymentId,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
////////////////////////////////////
class User {
    User({
        required this.id,required this.name, required this.email,required this.mobile
    });

    dynamic id;
    String name='ssss';
    String email;
    String mobile;

    factory User.fromJson(Map<String, dynamic> json) => User(

        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],

    );

    Map<String, dynamic> toJson() => {

        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,

    };
}


class LastOrder {
    LastOrder({
        required this.id,
        required this.status,
        required this.orderType,
        required this.order,
        required this.shopRevenue,
        required this.adminRevenue,
        required this.deliveryFee,
        required this.total,
        required this.otp,
        this.couponDiscount,
        required this.latitude,
        required this.longitude,
        this.couponId,
        required this.deliveryBoyId,
        required this.userId,
        required this.addressId,
        this.shopId,
        required this.orderPaymentId,
        required this.count,
        required this.type,
        required this.createdAt,
        required this.updatedAt,
        required this.carts,
        this.shop,
        this.deliveryBoyReview,
        required this.orderPayment,
         this.userOrder,
         this.addressOrder,
    });

    dynamic id;
    dynamic status;
    dynamic orderType;
    dynamic order;
    dynamic shopRevenue;
    dynamic adminRevenue;
    dynamic deliveryFee;
    dynamic total;
    dynamic otp;
    dynamic couponDiscount;
    dynamic latitude;
    dynamic longitude;
    dynamic couponId;
    dynamic deliveryBoyId;
    dynamic userId;
    dynamic addressId;
    dynamic? shopId;
    dynamic orderPaymentId;
    dynamic count;
    dynamic type;
    String createdAt;
    String updatedAt;
    List<dynamic> carts;
    Shop? shop;
    DeliveryBoyReview? deliveryBoyReview;
      OrderPayment orderPayment;
      User ?userOrder;
      Address ?addressOrder;


    factory LastOrder.fromJson(Map<String, dynamic> json) => LastOrder(
        id: json["id"],
        status: json["status"],
        orderType: json["order_type"],
        order: json["order"]?.toDouble(),
        shopRevenue: json["shop_revenue"],
        adminRevenue: json["admin_revenue"],
        deliveryFee: json["delivery_fee"],
        total: json["total"]?.toDouble(),
        otp: json["otp"],
        couponDiscount: json["coupon_discount"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        couponId: json["coupon_id"],
        deliveryBoyId: json["delivery_boy_id"],
        userId: json["user_id"],
        addressId: json["address_id"],
        shopId: json["shop_id"],
        orderPaymentId: json["order_payment_id"],
        count: json["count"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        carts: List<dynamic>.from(json["carts"].map((x) => x)),
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
        deliveryBoyReview: json["delivery_boy_review"] == null ? null : DeliveryBoyReview.fromJson(json["delivery_boy_review"]),
        orderPayment: OrderPayment.fromJson(json["order_payment"]),
        userOrder: json["user"] == null ? null : User.fromJson(json["user"]),
        addressOrder: json["user_address"] == null ? null : Address.fromJson(json["user_address"]),

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "order_type": orderType,
        "order": order,
        "shop_revenue": shopRevenue,
        "admin_revenue": adminRevenue,
        "delivery_fee": deliveryFee,
        "total": total,
        "otp": otp,
        "coupon_discount": couponDiscount,
        "latitude": latitude,
        "longitude": longitude,
        "coupon_id": couponId,
        "delivery_boy_id": deliveryBoyId,
        "user_id": userId,
        "address_id": addressId,
        "shop_id": shopId,
        "order_payment_id": orderPaymentId,
        "count": count,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "carts": List<dynamic>.from(carts.map((x) => x)),
        "shop": shop?.toJson(),
        "delivery_boy_review": deliveryBoyReview,
        "order_payment": orderPayment.toJson(),
        "user": userOrder?.toJson(),
        "user_address": addressOrder?.toJson(),
    };
}

class DeliveryBoyReview {
    DeliveryBoyReview({
        required this.id,
        required this.rating,
        this.review,
        required this.userId,
        required this.orderId,
        required this.deliveryBoyId,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    int rating;
    dynamic review;
    int userId;
    int orderId;
    int deliveryBoyId;
    DateTime createdAt;
    DateTime updatedAt;

    factory DeliveryBoyReview.fromJson(Map<String, dynamic> json) => DeliveryBoyReview(
        id: json["id"],
        rating: json["rating"],
        review: json["review"],
        userId: json["user_id"],
        orderId: json["order_id"],
        deliveryBoyId: json["delivery_boy_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "review": review,
        "user_id": userId,
        "order_id": orderId,
        "delivery_boy_id": deliveryBoyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}