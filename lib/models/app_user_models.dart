AppUserData appUserData = AppUserData();

class AppUserData {
  Data? data;
  bool? status;
  String? stateNum;
  String? message;

  AppUserData({this.data, this.status, this.stateNum, this.message});

  AppUserData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    stateNum = json['stateNum'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    data['stateNum'] = this.stateNum;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  DeliveryBoy? deliveryBoy;
  String? token;

  Data({this.deliveryBoy, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    deliveryBoy = json['deliveryBoy'] != null
        ? new DeliveryBoy.fromJson(json['deliveryBoy'])
        : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryBoy != null) {
      data['deliveryBoy'] = this.deliveryBoy!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class DeliveryBoy {
  int? id;
  Name? name;
  AgencyName? agencyName;
  String? carNumber;
  String? email;
  String? emailVerifiedAt;
  String? password;
  String? fcmToken;
  double? latitude;
  double? longitude;
  int? isFree;
  int? isOffline;
  int? isActive;
  String? avatarUrl;
  String? mobile;
  int? mobileVerified;
  int? rating;
  int? totalRating;
  int? categoryId;
  int? shopId;
  String? rememberToken;
  int? isVerified;
  String? drivingLicense;
  String? carLicense;
  int? isApproval;
  int? distance;
  String? otp;
  int? totalCapacity;
  int? totalQuantity;
  int? availableQuantity;
  String? referrer;
  String? referrerLink;
  String? createdAt;
  String? updatedAt;
  Category? category;

  DeliveryBoy(
      {this.id,
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
      this.category});

  DeliveryBoy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    agencyName =
        json['agency_name'] != null ? AgencyName.fromJson(json['name']) : null;

    carNumber = json['car_number'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    fcmToken = json['fcm_token'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isFree = json['is_free'];
    isOffline = json['is_offline'];
    isActive = json['is_active'];
    avatarUrl = json['avatar_url'];
    mobile = json['mobile'];
    mobileVerified = json['mobile_verified'];
    rating = json['rating'];
    totalRating = json['total_rating'];
    categoryId = json['category_id'];
    shopId = json['shop_id'];
    rememberToken = json['remember_token'];
    isVerified = json['is_verified'];
    drivingLicense = json['driving_license'];
    carLicense = json['car_license'];
    isApproval = json['is_approval'];
    distance = json['distance'];
    otp = json['otp'];
    totalCapacity = json['total_capacity'];
    totalQuantity = json['total_quantity'];
    availableQuantity = json['available_quantity'];
    referrer = json['referrer'];
    referrerLink = json['referrer_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name!.toJson();
    }
    data['agency_name'] = this.agencyName;
    data['car_number'] = this.carNumber;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['fcm_token'] = this.fcmToken;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_free'] = this.isFree;
    data['is_offline'] = this.isOffline;
    data['is_active'] = this.isActive;
    data['avatar_url'] = this.avatarUrl;
    data['mobile'] = this.mobile;
    data['mobile_verified'] = this.mobileVerified;
    data['rating'] = this.rating;
    data['total_rating'] = this.totalRating;
    data['category_id'] = this.categoryId;
    data['shop_id'] = this.shopId;
    data['remember_token'] = this.rememberToken;
    data['is_verified'] = this.isVerified;
    data['driving_license'] = this.drivingLicense;
    data['car_license'] = this.carLicense;
    data['is_approval'] = this.isApproval;
    data['distance'] = this.distance;
    data['otp'] = this.otp;
    data['total_capacity'] = this.totalCapacity;
    data['total_quantity'] = this.totalQuantity;
    data['available_quantity'] = this.availableQuantity;
    data['referrer'] = this.referrer;
    data['referrer_link'] = this.referrerLink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Name {
  String? en;
  String? ar;

  Name({this.en, this.ar});

  Name.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class AgencyName {
  String? en;
  String? ar;

  AgencyName({this.en, this.ar});

  AgencyName.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}

class Category {
  int? id;
  Name? title;
  Name? description;
  double? commesion;
  String? imageUrl;
  String? type;
  num? deliveryFee;
  String? expeditedFees;
  String? schedulerFees;
  String? startWorkTime;
  String? endWorkTime;
  int? active;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
      this.title,
      this.description,
      this.commesion,
      this.imageUrl,
      this.type,
      this.deliveryFee,
      this.expeditedFees,
      this.schedulerFees,
      this.startWorkTime,
      this.endWorkTime,
      this.active,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    commesion = json['commesion'];
    imageUrl = json['image_url'];
    type = json['type'];
    deliveryFee = json['delivery_fee'];
    expeditedFees = json['expedited_fees'];
    schedulerFees = json['scheduler_fees'];
    startWorkTime = json['start_work_time'];
    endWorkTime = json['end_work_time'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['commesion'] = this.commesion;
    data['image_url'] = this.imageUrl;
    data['type'] = this.type;
    data['delivery_fee'] = this.deliveryFee;
    data['expedited_fees'] = this.expeditedFees;
    data['scheduler_fees'] = this.schedulerFees;
    data['start_work_time'] = this.startWorkTime;
    data['end_work_time'] = this.endWorkTime;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
