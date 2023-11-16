class DeliveryBoyModel2 {
  final DeliveryBoyData2? data;
  final bool? status;
  final String? stateNum;
  final String? message;

  DeliveryBoyModel2({
    required this.data,
    required this.status,
    required this.stateNum,
    required this.message,
  });

  factory DeliveryBoyModel2.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyModel2(
      data: DeliveryBoyData2.fromJson(json['data']),
      status: json['status'],
      stateNum: json['stateNum'],
      message: json['message'],
    );
  }
}

class DeliveryBoyData2 {
  final DeliveryBoy2? deliveryBoy;
  final String? token;

  DeliveryBoyData2({
    required this.deliveryBoy,
    required this.token,
  });

  factory DeliveryBoyData2.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyData2(
      deliveryBoy: DeliveryBoy2.fromJson(json['deliveryBoy']),
      token: json['token'],
    );
  }
}

class DeliveryBoy2 {
  final int? id;
  final Name2? name;
  // final String? agencyName;
  // final String? carNumber;
   final String? email;
  // final dynamic emailVerifiedAt;
  // final String? password;
  // final dynamic fcmToken;
   final dynamic latitude;
   final dynamic longitude;
  final int? isFree;
  final int? isOffline;
  final int? isActive;
  final String? avatarUrl;
  final String? mobile;
  final int? mobileVerified;
  // final double? rating;
  // final double? totalRating;
  final int? categoryId;
   final int? shopId;
  // final dynamic rememberToken;
  // final int? isVerified;
   final String? drivingLicense;
   final int? isApproval;
   final int? distance;
  // final dynamic otp;
  // final int? fullGasBottles;
  // final int? emptyGasBottles;
  // final int? gasBottlesCapacity;
   final int? totalQuantity;
  final int? totalCapacity;

   final int? availableQuantity;
  final int? totalOrder;

  // final dynamic referrer;
  // final dynamic referrerLink;
  // final String? createdAt;
  // final String? updatedAt;
//  final Category2? category;

  DeliveryBoy2({
    required this.id,
    required this.name,
    // required this.agencyName,
    // required this.carNumber,
     required this.email,
    // required this.emailVerifiedAt,
    // required this.password,
    // required this.fcmToken,
     required this.latitude,
     required this.longitude,
    required this.isFree,
    required this.isOffline,
    required this.isActive,
    required this.avatarUrl,
    required this.mobile,
    required this.mobileVerified,
    // required this.rating,
    // required this.totalRating,
    required this.categoryId,
     required this.shopId,
    // required this.rememberToken,
    // required this.isVerified,
     required this.drivingLicense,
     required this.isApproval,
    required this.distance,
    // required this.otp,
    // required this.fullGasBottles,
    // required this.emptyGasBottles,
    // required this.gasBottlesCapacity,
     required this.totalQuantity,
     required this.availableQuantity,
    required this.totalCapacity,
    required this.totalOrder,
    // required this.referrer,
    // required this.referrerLink,
    // required this.createdAt,
    // required this.updatedAt,
  //  required this.category,
  });

  factory DeliveryBoy2.fromJson(Map<String, dynamic> json) {
    return DeliveryBoy2(
      id: json['id'],
       name: json['name'] != null ? Name2.fromJson(json['name']) : null,
      // agencyName: json['agency_name'],
      // carNumber: json['car_number'],
       email: json['email'],
      // emailVerifiedAt: json['email_verified_at'],
      // password: json['password'],
      // fcmToken: json['fcm_token'],
       latitude: json['latitude'],
       longitude: json['longitude'],
      isFree: json['is_free'],
      isOffline: json['is_offline'],
      isActive: json['is_active'],
      avatarUrl: json['avatar_url'],
      mobile: json['mobile'],
      mobileVerified: json['mobile_verified'],
      // rating: json['rating'],
      // totalRating: json['total_rating'],
      categoryId: json['category_id'],
       shopId: json['shop_id'],
      // rememberToken: json['remember_token'],
      // isVerified: json['is_verified'],
       drivingLicense: json['driving_license'],
      isApproval: json['is_approval'],
       distance: json['distance'],
      // otp: json['otp'],
      // fullGasBottles: json['full_gas_bottles'],
      // emptyGasBottles: json['empty_gas_bottles'],
      // gasBottlesCapacity: json['gas_bottles_capacity'],
      totalCapacity: json['total_capacity']??0,
      totalOrder:json['order_total']??0,
       totalQuantity: json['total_quantity']??0,
       availableQuantity: json['available_quantity']??0,
      // referrer: json['referrer'],
      // referrerLink: json['referrer_link'],
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
    //  category: json['category'] != null ? Category2.fromJson(json['category']) : null,
    );
  }
}

class Name2 {
  final String? en;
  final String? ar;

  Name2({
    required this.en,
    required this.ar,
  });

  factory Name2.fromJson(Map<String, dynamic> json) {
    return Name2(
      en: json['en'],
      ar: json['ar'],
    );
  }
}

class Category2 {
  final int? id;
  final Title2? title;
  final Description2? description;
  final double? commesion;
  final String? imageUrl;
  final String? type;
  final double? deliveryFee;
  final dynamic expeditedFees;
  final dynamic schedulerFees;
  final String? startWorkTime;
  final String? endWorkTime;
  final int? active;
  final String? createdAt;
  final String? updatedAt;

  Category2({
    required this.id,
    required this.title,
    required this.description,
    required this.commesion,
    required this.imageUrl,
    required this.type,
    required this.deliveryFee,
    required this.expeditedFees,
    required this.schedulerFees,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category2.fromJson(Map<String, dynamic> json) {
    return Category2(
      id: json['id'],
      title: json['title'] != null ? Title2.fromJson(json['title']) : null,
      description: json['description'] != null ? Description2.fromJson(json['description']) : null,
      commesion: json['commesion'],
      imageUrl: json['image_url'],
      type: json['type'],
      deliveryFee: json['delivery_fee'],
      expeditedFees: json['expedited_fees'],
      schedulerFees: json['scheduler_fees'],
      startWorkTime: json['start_work_time'],
      endWorkTime: json['end_work_time'],
      active: json['active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Title2 {
  final String? en;
  final String? ar;

  Title2({
    required this.en,
    required this.ar,
  });

  factory Title2.fromJson(Map<String, dynamic> json) {
    return Title2(
      en: json['en'],
      ar: json['ar'],
    );
  }
}

class Description2 {
  final String? en;
  final String? ar;

  Description2({
    required this.en,
    required this.ar,
  });

  factory Description2.fromJson(Map<String, dynamic> json) {
    return Description2(
      en: json['en'],
      ar: json['ar'],
    );
  }
}
