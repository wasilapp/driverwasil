

class DeliveryBoyShow {
  int? id;
  Name? name;
  Null? agencyName;
  String? carNumber;
  String? email;
  Null? emailVerifiedAt;
  String? password;
  Null? fcmToken;
  Null? latitude;
  Null? longitude;
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
  Null? rememberToken;
  int? isVerified;
  String? drivingLicense;
  String? carLicense;
  int? isApproval;
  int? distance;
  Null? otp;
  int? totalCapacity;
  int ?totalQuantity;
  int ?availableQuantity;
  String? referrer;
  Null? referrerLink;
  String? createdAt;
  String? updatedAt;
  List<SubCategory>? subCategory;

  DeliveryBoyShow(
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
        this.subCategory});

  DeliveryBoyShow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    agencyName = json['agency_name'];
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
    totalQuantity = json['total_quantity']??0;
    availableQuantity = json['available_quantity']??0;
    referrer = json['referrer'];
    referrerLink = json['referrer_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['sub_category'] != null) {
      subCategory = <SubCategory>[];
      json['sub_category'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
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
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.map((v) => v.toJson()).toList();
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

class SubCategory {
  int? id;
  Name? title;
  Name? description;
  double? price;
  Null? shopId;
  int? categoryId;
  int? active;
  int? isPrimary;
  String? imageUrl;
  int? isApproval;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  Details? details;

  SubCategory(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.shopId,
        this.categoryId,
        this.active,
        this.isPrimary,
        this.imageUrl,
        this.isApproval,
        this.quantity,
        this.createdAt,
        this.updatedAt,
        this.details});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    price = json['price'];
    shopId = json['shop_id'];
    categoryId = json['category_id'];
    active = json['active'];
    isPrimary = json['is_primary'];
    imageUrl = json['image_url'];
    isApproval = json['is_approval'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
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
    data['price'] = this.price;
    data['shop_id'] = this.shopId;
    data['category_id'] = this.categoryId;
    data['active'] = this.active;
    data['is_primary'] = this.isPrimary;
    data['image_url'] = this.imageUrl;
    data['is_approval'] = this.isApproval;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  int? deliveryBoyId;
  int? subCategoryId;
  Null? price;
  String? totalQuantity;
  String? availableQuantity;

  Details(
      {this.deliveryBoyId,
        this.subCategoryId,
        this.price,
        this.totalQuantity,
        this.availableQuantity});

  Details.fromJson(Map<String, dynamic> json) {
    deliveryBoyId = json['delivery_boy_id'];
    subCategoryId = json['sub_category_id'];
    price = json['price'];
    totalQuantity = json['total_quantity'];
    availableQuantity = json['available_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_boy_id'] = this.deliveryBoyId;
    data['sub_category_id'] = this.subCategoryId;
    data['price'] = this.price;
    data['total_quantity'] = this.totalQuantity;
    data['available_quantity'] = this.availableQuantity;
    return data;
  }
}
