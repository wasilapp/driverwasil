// // To parse this JSON data, do
// //
// //     final category = categoryFromMap(jsonString);
//
// import 'dart:convert';
// import 'dart:developer';
//
// List<Category> categoryFromMap(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromMap(x)));
//
// List<SubCategory> subCategoryFromMap(String str) => List<SubCategory>.from(json.decode(str).map((x) => SubCategory.fromMap(x)));
//
// List<Shop> shopsFromMap(String str) => List<Shop>.from(json.decode(str).map((x) => Shop.fromMap(x)));
//
// String categoryToMap(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));
//
// class Category {
//     Category({
//         required this.id,
//         required this.title,
//         required this.commesion,
//         required this.imageUrl,
//         this.deliveryFee,
//         required this.active,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.subCategories,
//         required this.shops,
//     });
//
//     int id;
//     String title;
//     double commesion;
//     String imageUrl;
//     dynamic deliveryFee;
//     int active;
//     String createdAt;
//     String updatedAt;
//     List<SubCategory> subCategories;
//     List<Shop> shops;
//
//     factory Category.fromMap(Map<String, dynamic> json){
//       log("here in the category");
//      return  Category(
//         id: json["id"],
//         title: json["title"],
//         commesion: json["commesion"]==null ? 0 :  json["commesion"].toDouble() ?? 0,
//         imageUrl: json["image_url"],
//         deliveryFee: json["delivery_fee"]==null ? 0 :  json["delivery_fee"].toDouble(),
//         active: json["active"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         subCategories: json["sub_categories"].isEmpty ? [] :  List<SubCategory>.from(json["sub_categories"].map((x) => SubCategory.fromMap(x))),
//         shops:  json["shops"].isEmpty ? [] :  List<Shop>.from(json["shops"].map((x) => Shop.fromMap(x))),
//     );
//     }
//     Map<String, dynamic> toMap() => {
//         "id": id,
//         "title": title,
//         "commesion": commesion,
//         "image_url": imageUrl,
//         "delivery_fee": deliveryFee,
//         "active": active,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "sub_categories": List<dynamic>.from(subCategories.map((x) => x.toMap())),
//         "shops": List<dynamic>.from(shops.map((x) => x.toMap())),
//     };
// }
//
// class Shop {
//     Shop({
//         required this.id,
//         required this.name,
//         required this.email,
//         required this.mobile,
//         required this.barcode,
//         required this.latitude,
//         required this.longitude,
//         required this.address,
//         required this.imageUrl,
//         required this.rating,
//         required this.deliveryRange,
//         required this.totalRating,
//         this.defaultTax,
//         required this.availableForDelivery,
//         required this.open,
//         required this.managerId,
//         required this.categoryId,
//         required this.createdAt,
//         required this.updatedAt,
//     });
//
//     int id;
//     String name;
//     String email;
//     String mobile;
//     String barcode;
//     double latitude;
//     double longitude;
//     String address;
//     String imageUrl;
//     int rating;
//     int deliveryRange;
//     int totalRating;
//     int? defaultTax;
//     int availableForDelivery;
//     int open;
//     int? managerId;
//     int categoryId;
//     String createdAt;
//     String updatedAt;
//
//     factory Shop.fromMap(Map<String, dynamic> json) => Shop(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         mobile: json["mobile"],
//         barcode: json["barcode"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         address: json["address"],
//         imageUrl: json["image_url"],
//         rating: json["rating"],
//         deliveryRange: json["delivery_range"],
//         totalRating: json["total_rating"],
//         defaultTax: json["default_tax"],
//         availableForDelivery: json["available_for_delivery"],
//         open: json["open"],
//         managerId: json["manager_id"],
//         categoryId: json["category_id"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//     );
//
//     Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "mobile": mobile,
//         "barcode": barcode,
//         "latitude": latitude,
//         "longitude": longitude,
//         "address": address,
//         "image_url": imageUrl,
//         "rating": rating,
//         "delivery_range": deliveryRange,
//         "total_rating": totalRating,
//         "default_tax": defaultTax,
//         "available_for_delivery": availableForDelivery,
//         "open": open,
//         "manager_id": managerId,
//         "category_id": categoryId,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//     };
//
//       static String getPlaceholderImage(){
//     return './assets/images/placeholder/no-shop-image.png';
//   }
// }
//
// class SubCategory {
//     SubCategory({
//         required this.id,
//         required this.title,
//         required this.price,
//         required this.categoryId,
//         required this.active,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.image_url,
//     });
//
//     int id;
//     String title;
//     double price;
//     int categoryId;
//     int active;
//     String createdAt;
//     String updatedAt;
//    String image_url;
//
//     factory SubCategory.fromMap(Map<String, dynamic> json) {
//
//       log("in the sub");
//
//      return SubCategory(
//         id: json["id"],
//         title: json["title"],
//         price: json["price"]?.toDouble(),
//         categoryId: json["category_id"],
//         active: json["active"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//          image_url: json["image_url"],
//     );
//
//     }
//
//     Map<String, dynamic> toMap() => {
//         "id": id,
//         "title": title,
//         "price": price,
//         "category_id": categoryId,
//         "active": active,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "image_url": image_url,
//     };
// }
class Autogenerated {
    Data? data;
    bool? status;
    String? stateNum;
    String? message;

    Autogenerated({this.data, this.status, this.stateNum, this.message});

    Autogenerated.fromJson(Map<String, dynamic> json) {
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
    List<Categories>? categories;

    Data({this.categories});

    Data.fromJson(Map<String, dynamic> json) {
        if (json['categories'] != null) {
            categories = <Categories>[];
            json['categories'].forEach((v) {
                categories!.add(new Categories.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.categories != null) {
            data['categories'] = this.categories!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Categories {
    int? id;
    Title? title;
    Title? description;
    double? commesion;
    String? imageUrl;
    String? type;
    int? deliveryFee;
    Null? expeditedFees;
    Null? schedulerFees;
    String? startWorkTime;
    String? endWorkTime;
    int? active;
    String? createdAt;
    String? updatedAt;
    // List<Shops>? shops;

    Categories(
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
            this.updatedAt,
            // this.shops
        });

    Categories.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        title = json['title'] != null ? new Title.fromJson(json['title']) : null;
        description = json['description'] != null
            ? new Title.fromJson(json['description'])
            : null;
        commesion = double.parse(json['commesion'].toString());
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
        // if (json['shops'] != null) {
        //     shops = <Shops>[];
        //     json['shops'].forEach((v) {
        //         shops!.add(new Shops.fromJson(v));
        //     });
        // }
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
        // if (this.shops != null) {
        //     data['shops'] = this.shops!.map((v) => v.toJson()).toList();
        // }
        return data;
    }
}

class Title {
    String? en;
    String? ar;

    Title({this.en, this.ar});

    Title.fromJson(Map<String, dynamic> json) {
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

// class Shops {
//     int? id;
//     Title? name;
//     String? email;
//     String? mobile;
//     String? barcode;
//     double? latitude;
//     double? longitude;
//     String? address;
//     String? imageUrl;
//     int? rating;
//     int? deliveryRange;
//     int? totalRating;
//     int? defaultTax;
//     int? availableForDelivery;
//     int? open;
//     int? managerId;
//     int? categoryId;
//     int? distance;
//     String? createdAt;
//     String? updatedAt;
//
//     Shops(
//         {this.id,
//             this.name,
//             this.email,
//             this.mobile,
//             this.barcode,
//             this.latitude,
//             this.longitude,
//             this.address,
//             this.imageUrl,
//             this.rating,
//             this.deliveryRange,
//             this.totalRating,
//             this.defaultTax,
//             this.availableForDelivery,
//             this.open,
//             this.managerId,
//             this.categoryId,
//             this.distance,
//             this.createdAt,
//             this.updatedAt});
//
//     Shops.fromJson(Map<String, dynamic> json) {
//         id = json['id'];
//         name = json['name'] != null ? new Title.fromJson(json['name']) : null;
//         email = json['email'];
//         mobile = json['mobile'];
//         barcode = json['barcode'];
//         latitude = json['latitude'];
//         longitude = json['longitude'];
//         address = json['address'];
//         imageUrl = json['image_url'];
//         rating = json['rating'];
//         deliveryRange = json['delivery_range'];
//         totalRating = json['total_rating'];
//         defaultTax = json['default_tax'];
//         availableForDelivery = json['available_for_delivery'];
//         open = json['open'];
//         managerId = json['manager_id'];
//         categoryId = json['category_id'];
//         distance = json['distance'];
//         createdAt = json['created_at'];
//         updatedAt = json['updated_at'];
//     }
//
//     Map<String, dynamic> toJson() {
//         final Map<String, dynamic> data = new Map<String, dynamic>();
//         data['id'] = this.id;
//         if (this.name != null) {
//             data['name'] = this.name!.toJson();
//         }
//         data['email'] = this.email;
//         data['mobile'] = this.mobile;
//         data['barcode'] = this.barcode;
//         data['latitude'] = this.latitude;
//         data['longitude'] = this.longitude;
//         data['address'] = this.address;
//         data['image_url'] = this.imageUrl;
//         data['rating'] = this.rating;
//         data['delivery_range'] = this.deliveryRange;
//         data['total_rating'] = this.totalRating;
//         data['default_tax'] = this.defaultTax;
//         data['available_for_delivery'] = this.availableForDelivery;
//         data['open'] = this.open;
//         data['manager_id'] = this.managerId;
//         data['category_id'] = this.categoryId;
//         data['distance'] = this.distance;
//         data['created_at'] = this.createdAt;
//         data['updated_at'] = this.updatedAt;
//         return data;
//     }
// }
