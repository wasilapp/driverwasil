// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:DeliveryBoyApp/utils/TextUtils.dart';

class DeliveryBoy {

  int? id;
  bool? isOffline = false,mobileVerified;
  bool? isFree;
  int? rating;
  int? totalRating;
  int? shopId;
  bool? rememberToken;
  String? name,email,token,avatarUrl,mobile;
  String? type;



  DeliveryBoy(this.id,this.name, this.email, this.token,
      this.avatarUrl, this.mobile,this.isOffline,this.mobileVerified,this.isFree,this.rating,this.totalRating,this.shopId,this.rememberToken,this.type);


  static DeliveryBoy fromJson(Map<String, dynamic> jsonObject,String type){

    int? id = jsonObject['id'];
    String? name = jsonObject['name'].toString();
    String? email = jsonObject['email'].toString();
    String? avatarUrl = jsonObject['avatar_url'].toString();
    String? mobile = jsonObject['mobile'].toString();
    
    bool isOffline = TextUtils.parseBool(jsonObject['is_offline']);
     bool isFree = TextUtils.parseBool(jsonObject['is_free']);
     int rating= jsonObject['rating'];
     int totalRating = jsonObject['total_rating'];
     int ? shopId= jsonObject['shop_id'] ==null ? null : jsonObject['shop_id'];
     bool rememberToken = TextUtils.parseBool(jsonObject['remember_token']);
    bool mobileVerified = TextUtils.parseBool(jsonObject['mobile_verified']);


    return DeliveryBoy(id,name, email, null, avatarUrl, mobile, isOffline,mobileVerified,isFree,rating,totalRating,shopId,rememberToken,type);
  }

  @override
  String toString() {
    return 'DeliveryBoy{id: $id, isOffline: $isOffline, name: $name, email: $email, token: $token, avatarUrl: $avatarUrl, mobile: $mobile}';
  }

  String getAvatarUrl(){
    return TextUtils.getImageUrl(avatarUrl);
  }


    DeliveryBoy fromMap(Map<String, dynamic> jsonObject,{String lat="",String long=""}){

    int? id = jsonObject['id'] ?? 14234235235;
    String? name = jsonObject['name'].toString();
    String? email = jsonObject['email'].toString();
    String? avatarUrl = jsonObject['avatar_url'].toString();
    String? mobile = jsonObject['mobile'].toString();
        
    bool isOffline = TextUtils.parseBool(jsonObject['is_offline']);
     bool isFree = TextUtils.parseBool(jsonObject['is_free']);
     int rating= jsonObject['rating'];
     int totalRating = jsonObject['total_rating'];
     int shopId= jsonObject['shop_id'];
     bool rememberToken = TextUtils.parseBool(jsonObject['remember_token']);
    
   
    bool mobileVerified = TextUtils.parseBool(jsonObject['mobile_verified']);

       return DeliveryBoy(id,name, email, null, avatarUrl, mobile, isOffline,mobileVerified,isFree,rating,totalRating,shopId,rememberToken,type);

  }

  Map<String, dynamic> toMap({double lat=0.0,double long=0.0}) {
    return <String, dynamic>{
      'id': id,
      'isOffline': isOffline,
      'isFree' : isFree,
      'name': name,
      'email':email,
      'type' : type,
      'shop_id' : shopId,
     // 'token':token,
      'avatarUrl':'avatar_url',
      'mobile':mobile,
      "lat":lat,
      "long":long
    };
  }



  String toJson() => json.encode(toMap());

}




class DeliveryBoyModel {
  int? id;
  Name? name;
  String? agencyName;
  String? carNumber;
  String? email;
  int? emailVerifiedAt;
  String? password;
  String? fcmToken;
  String  ? longitude;
  String  ? latitude;
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
  int? rememberToken;
  int? isVerified;
  String? drivingLicense;
  int? isApproval;
  int? distance;
  int? otp;
  int? fullGasBottles;
  int? emptyGasBottles;
  int? gasBottlesCapacity;
  int? totalQuantity;
  int? availableQuantity;
  String? createdAt;
  String? updatedAt;
  Category? category;

  DeliveryBoyModel(
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
        this.isApproval,
        this.distance,
        this.otp,
        this.fullGasBottles,
        this.emptyGasBottles,
        this.gasBottlesCapacity,
        this.totalQuantity,
        this.availableQuantity,
        this.createdAt,
        this.updatedAt,
        this.category});

  DeliveryBoyModel.fromJson(Map<String, dynamic> json) {
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
    isApproval = json['is_approval'];
    distance = json['distance'];
    otp = json['otp'];
    fullGasBottles = json['full_gas_bottles'];
    emptyGasBottles = json['empty_gas_bottles'];
    gasBottlesCapacity = json['gas_bottles_capacity'];
    totalQuantity = json['total_quantity'];
    availableQuantity = json['available_quantity'];
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
    data['is_approval'] = this.isApproval;
    data['distance'] = this.distance;
    data['otp'] = this.otp;
    data['full_gas_bottles'] = this.fullGasBottles;
    data['empty_gas_bottles'] = this.emptyGasBottles;
    data['gas_bottles_capacity'] = this.gasBottlesCapacity;
    data['total_quantity'] = this.totalQuantity;
    data['available_quantity'] = this.availableQuantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
  // @override
  // String toString() {
  //   return 'DeliveryBoy{id: $id, isOffline: $isOffline, name: $name, email: $email, token: $token, avatarUrl: $avatarUrl, mobile: $mobile}';
  // }

  String getAvatarUrl(){
    return TextUtils.getImageUrl(avatarUrl);
  }


  DeliveryBoyModel fromMap(Map<String, dynamic> jsonObject,{String lat="",String long=""}){

    int? id = jsonObject['id'] ?? 14234235235;
    String? name = jsonObject['name'].toString();
    String? email = jsonObject['email'].toString();
    String? avatarUrl = jsonObject['avatar_url'].toString();
    String? mobile = jsonObject['mobile'].toString();

    bool isOffline = TextUtils.parseBool(jsonObject['is_offline']);
    bool isFree = TextUtils.parseBool(jsonObject['is_free']);
    int rating= jsonObject['rating'];
    int totalRating = jsonObject['total_rating'];
    int shopId= jsonObject['shop_id'];
    bool rememberToken = TextUtils.parseBool(jsonObject['remember_token']);


    bool mobileVerified = TextUtils.parseBool(jsonObject['mobile_verified']);

    return DeliveryBoyModel(
      id: id,carNumber: carNumber,agencyName: agencyName,categoryId: categoryId,shopId: shopId,name: Name(en: name),email: email,mobile: mobile,
);

  }

  Map<String, dynamic> toMap({double lat=0.0,double long=0.0}) {
    return <String, dynamic>{
      'id': id,
      'isOffline': isOffline,
      'isFree' : isFree,
      'name': name,
      'email':email,
 
      'shop_id' : shopId,
      // 'token':token,
      'avatarUrl':'avatar_url',
      'mobile':mobile,
      "lat":lat,
      "long":long
    };
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

class Category {
  int? id;
  Name? title;
  Name? description;
  double? commesion;
  String? imageUrl;
  String? type;
  int? deliveryFee;
  double? expeditedFees;
  double? schedulerFees;
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
