class BoyData {
  int? id;
  Nameboy? name;
  String? email;
  String? mobile;
  String? barcode;
  double? latitude;
  double? longitude;
  String? address;
  String? imageUrl;
  double? rating;
  double? deliveryRange;
  double? totalRating;
  double? defaultTax;
  double? availableForDelivery;
  double? open;
  int? managerId;
  int? categoryId;
  double? distance;
  String? createdAt;
  String? updatedAt;
  List<SubCategoryBoy>? subCategory;

  BoyData({
    this.id,
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
    this.subCategory,
  });

  factory BoyData.fromJson(Map<String, dynamic> json) => BoyData(
    id: json['id'],
    name: json['name'] != null ? Nameboy.fromJson(json['name']) : null,
    email: json['email'],
    mobile: json['mobile'],
    barcode: json['barcode'],
    latitude: json['latitude']?.toDouble(),
    longitude: json['longitude']?.toDouble(),
    address: json['address'],
    imageUrl: json['image_url'],
    rating: json['rating']?.toDouble(),
    deliveryRange: json['delivery_range']?.toDouble(),
    totalRating: json['total_rating']?.toDouble(),
    defaultTax: json['default_tax']?.toDouble(),
    availableForDelivery: json['available_for_delivery']?.toDouble(),
    open: json['open']?.toDouble(),
    managerId: json['manager_id'],
    categoryId: json['category_id'],
    distance: json['distance']?.toDouble(),
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    subCategory: json['sub_category'] != null
        ? List<SubCategoryBoy>.from(
        json['sub_category'].map((x) => SubCategoryBoy.fromJson(x)))
        : [],
  );
}

class Nameboy {
  String? en;
  String? ar;

  Nameboy({this.en, this.ar});

  factory Nameboy.fromJson(Map<String, dynamic> json) => Nameboy(
    en: json['en'],
    ar: json['ar'],
  );
}

class SubCategoryBoy {
  // Add fields for SubCategory as needed

  SubCategoryBoy();

  factory SubCategoryBoy.fromJson(Map<String, dynamic> json) {
    // Implement SubCategory.fromJson logic here
    return SubCategoryBoy();
  }
}
