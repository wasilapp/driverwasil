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
