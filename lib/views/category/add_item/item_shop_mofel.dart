

class Shop {
  int? id;
  Name? name;
  Null? email;
  Null? mobile;
  String? barcode;
  double? latitude;
  double? longitude;
  String? address;
  Null? imageUrl;
  int? rating;
  int? deliveryRange;
  int? totalRating;
  int? defaultTax;
  int? availableForDelivery;
  int? open;
  int? managerId;
  int? categoryId;
  int? distance;
  String? createdAt;
  String? updatedAt;
  List<SubCategory>? subCategory;

  Shop(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.barcode,
        this.latitude,
        this.longitude,
        this.address,
        this.imageUrl,
        this.rating,
        this.deliveryRange,
        this.totalRating,
        this.defaultTax,
        this.availableForDelivery,
        this.open,
        this.managerId,
        this.categoryId,
        this.distance,
        this.createdAt,
        this.updatedAt,
        this.subCategory});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    email = json['email'];
    mobile = json['mobile'];
    barcode = json['barcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    imageUrl = json['image_url'];
    rating = json['rating'];
    deliveryRange = json['delivery_range'];
    totalRating = json['total_rating'];
    defaultTax = json['default_tax'];
    availableForDelivery = json['available_for_delivery'];
    open = json['open'];
    managerId = json['manager_id'];
    categoryId = json['category_id'];
    distance = json['distance'];
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
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['barcode'] = this.barcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['image_url'] = this.imageUrl;
    data['rating'] = this.rating;
    data['delivery_range'] = this.deliveryRange;
    data['total_rating'] = this.totalRating;
    data['default_tax'] = this.defaultTax;
    data['available_for_delivery'] = this.availableForDelivery;
    data['open'] = this.open;
    data['manager_id'] = this.managerId;
    data['category_id'] = this.categoryId;
    data['distance'] = this.distance;
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
  int? shopId;
  int? categoryId;
  int? active;
  int? isPrimary;
  String? imageUrl;
  int? isApproval;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

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
        this.pivot});

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
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
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
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? shopId;
  int? subCategoryId;
  String? price;
  Null? quantity;
  String? isShow;

  Pivot(
      {this.shopId,
        this.subCategoryId,
        this.price,
        this.quantity,
        this.isShow});

  Pivot.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    subCategoryId = json['sub_category_id'];
    price = json['price'];
    quantity = json['quantity'];
    isShow = json['is_show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['sub_category_id'] = this.subCategoryId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['is_show'] = this.isShow;
    return data;
  }
}
