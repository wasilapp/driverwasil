class DeliveryBoyResponse {
  final bool status;
  final String stateNum;
  final String message;
  final DeliveryBoyData? data;

  DeliveryBoyResponse({
    required this.status,
    required this.stateNum,
    required this.message,
    this.data,
  });

  factory DeliveryBoyResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyResponse(
      status: json['status'],
      stateNum: json['stateNum'],
      message: json['message'],
      data: json['data'] != null ? DeliveryBoyData.fromJson(json['data']) : null,
    );
  }
}

class DeliveryBoyData {
  final DeliveryBoy? deliveryBoy;
  final String? token;

  DeliveryBoyData({
    this.deliveryBoy,
    this.token,
  });

  factory DeliveryBoyData.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyData(
      deliveryBoy: json['deliveryBoy'] != null ? DeliveryBoy.fromJson(json['deliveryBoy']) : null,
      token: json['token'],
    );
  }
}

class DeliveryBoy {
  final int id;
  final Map<String, String>? name;
  final String? agencyName;
  final String carNumber;
  final String email;
  final String? emailVerifiedAt;
  final String password;
  final String? fcmToken;
  final double? latitude;
  final double? longitude;
  final int isFree;
  final int isOffline;
  final int isActive;
  final String avatarUrl;
  final String mobile;
  final int mobileVerified;
  final double rating;
  final double totalRating;
  final int categoryId;
  final int shopId;
  final String? rememberToken;
  final int isVerified;
  final String drivingLicense;
  final String? carLicense;
  final int isApproval;
  final int distance;
  final String? otp;
  final int totalCapacity;
  final int totalQuantity;
  final int availableQuantity;
  final String? referrer;
  final String? referrerLink;
  final String createdAt;
  final String updatedAt;
  final DeliveryBoyCategory? category;

  DeliveryBoy({
    required this.id,
    required this.name,
    this.agencyName,
    required this.carNumber,
    required this.email,
    this.emailVerifiedAt,
    required this.password,
    this.fcmToken,
    this.latitude,
    this.longitude,
    required this.isFree,
    required this.isOffline,
    required this.isActive,
    required this.avatarUrl,
    required this.mobile,
    required this.mobileVerified,
    required this.rating,
    required this.totalRating,
    required this.categoryId,
    required this.shopId,
    this.rememberToken,
    required this.isVerified,
    required this.drivingLicense,
    this.carLicense,
    required this.isApproval,
    required this.distance,
    this.otp,
    required this.totalCapacity,
    required this.totalQuantity,
    required this.availableQuantity,
    this.referrer,
    this.referrerLink,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) {
    return DeliveryBoy(
      id: json['id'],
      name: Map<String, String>.from(json['name']),
      agencyName: json['agency_name'],
      carNumber: json['car_number'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      password: json['password'],
      fcmToken: json['fcm_token'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isFree: json['is_free'],
      isOffline: json['is_offline'],
      isActive: json['is_active'],
      avatarUrl: json['avatar_url'],
      mobile: json['mobile'],
      mobileVerified: json['mobile_verified'],
      rating: json['rating'],
      totalRating: json['total_rating'],
      categoryId: json['category_id'],
      shopId: json['shop_id'],
      rememberToken: json['remember_token'],
      isVerified: json['is_verified'],
      drivingLicense: json['driving_license'],
      carLicense: json['car_license'],
      isApproval: json['is_approval'],
      distance: json['distance'],
      otp: json['otp'],
      totalCapacity: json['total_capacity'],
      totalQuantity: json['total_quantity'],
      availableQuantity: json['available_quantity'],
      referrer: json['referrer'],
      referrerLink: json['referrer_link'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: json['category'] != null ? DeliveryBoyCategory.fromJson(json['category']) : null,
    );
  }
}

class DeliveryBoyCategory {
  final int id;
  final Map<String, String>? title;
  final Map<String, String>? description;
  final double commesion;
  final String imageUrl;
  final String type;
  final double deliveryFee;
  final double? expeditedFees;
  final double? schedulerFees;
  final String startWorkTime;
  final String endWorkTime;
  final int active;
  final String createdAt;
  final String updatedAt;

  DeliveryBoyCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.commesion,
    required this.imageUrl,
    required this.type,
    required this.deliveryFee,
    this.expeditedFees,
    this.schedulerFees,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryBoyCategory.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyCategory(
      id: json['id'],
      title: Map<String, String>.from(json['title']),
      description: Map<String, String>.from(json['description']),
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
