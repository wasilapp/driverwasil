import 'dart:convert';

class DeliveryBoy {
  final int? id;
  final Name? name;
  final String? agencyName;
  final String? carNumber;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? password;
  final String? fcmToken;
  final double? latitude;
  final double? longitude;
  final int? isFree;
  final int? isOffline;
  final int? isActive;
  final String? avatarUrl;
  final String? mobile;
  final int? mobileVerified;
  final double? rating;
  final double? totalRating;
  final int? categoryId;
  final int? shopId;
  final String? rememberToken;
  final int? isVerified;
  final String? drivingLicense;
  final String? carLicense;
  final int? isApproval;
  final int? distance;
  final int? otp;
  final int? totalCapacity;
  final int? totalQuantity;
  final int? availableQuantity;
  final String? referrer;
  final String? referrerLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? orderTotal;
  final List<Order>? orders;

  DeliveryBoy({
    this.id,
    this.name,
    this.agencyName,
    this.carNumber,
    this.email,
    this.emailVerifiedAt,
    this.password,
    this.fcmToken,
    this.latitude,
    this.longitude,
    this.isFree,
    this.isOffline,
    this.isActive,
    this.avatarUrl,
    this.mobile,
    this.mobileVerified,
    this.rating,
    this.totalRating,
    this.categoryId,
    this.shopId,
    this.rememberToken,
    this.isVerified,
    this.drivingLicense,
    this.carLicense,
    this.isApproval,
    this.distance,
    this.otp,
    this.totalCapacity,
    this.totalQuantity,
    this.availableQuantity,
    this.referrer,
    this.referrerLink,
    this.createdAt,
    this.updatedAt,
    this.orderTotal,
    this.orders,
  });

  factory DeliveryBoy.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Null JSON provided to DeliveryBoy");
    }

    return DeliveryBoy(
      id: json['id'] as int?,
      name: Name.fromJson(json['name'] as Map<String, dynamic>?),
      agencyName: json['agency_name'] as String?,
      carNumber: json['car_number'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at'] as String) : null,
      password: json['password'] as String?,
      fcmToken: json['fcm_token'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      isFree: json['is_free'] as int?,
      isOffline: json['is_offline'] as int?,
      isActive: json['is_active'] as int?,
      avatarUrl: json['avatar_url'] as String?,
      mobile: json['mobile'] as String?,
      mobileVerified: json['mobile_verified'] as int?,
      rating: json['rating'] as double?,
      totalRating: json['total_rating'] as double?,
      categoryId: json['category_id'] as int?,
      shopId: json['shop_id'] as int?,
      rememberToken: json['remember_token'] as String?,
      isVerified: json['is_verified'] as int?,
      drivingLicense: json['driving_license'] as String?,
      carLicense: json['car_license'] as String?,
      isApproval: json['is_approval'] as int?,
      distance: json['distance'] as int?,
      otp: json['otp'] as int?,
      totalCapacity: json['total_capacity'] as int?,
      totalQuantity: json['total_quantity'] as int?,
      availableQuantity: json['available_quantity'] as int?,
      referrer: json['referrer'] as String?,
      referrerLink: json['referrer_link'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      orderTotal: json['order_total'] as int?,
      orders: (json['orders'] as List<dynamic>?)?.map((e) => Order.fromJson(e as Map<String, dynamic>?)).toList(),
    );
  }
}

class Name {
  final String? en;
  final String? ar;

  Name({this.en, this.ar});

  factory Name.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Null JSON provided to Name");
    }

    return Name(
      en: json['en'] as String?,
      ar: json['ar'] as String?,
    );
  }
}

class Order {
  // Define the properties for the Order class based on your actual JSON structure.
  //For example:
  final int? orderId;
  final String? orderName;

  Order({this.orderId, this.orderName});

  factory Order.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Null JSON provided to Order");
    }

    return Order(
      orderId: json['orderId'] as int?,
      orderName: json['orderName'] as String?,
    );
  }
}

// Top-level function to parse JSON and create the DeliveryBoy object.
DeliveryBoy parseDeliveryBoy(String jsonStr) {
  final Map<String, dynamic>? json = jsonDecode(jsonStr);
  return DeliveryBoy.fromJson(json);
}
