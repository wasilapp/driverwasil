class BoySubCategory {
  final bool status;
  final String stateNum;
  final String message;
  final List<SubCategory> subCategories;

  BoySubCategory({
    required this.status,
    required this.stateNum,
    required this.message,
    required this.subCategories,
  });

  factory BoySubCategory.fromJson(Map<String, dynamic> json) {
    List<SubCategory> subCategoriesList = List<SubCategory>.from(
      json['data']['subCategories'].map((subcategory) => SubCategory.fromJson(subcategory)),
    );

    return BoySubCategory(
      status: json['status'],
      stateNum: json['stateNum'],
      message: json['message'],
      subCategories: subCategoriesList,
    );
  }
}

class SubCategory {
  final int id;
  final Map<String, String>? title;
  final Map<String, String>? description;
  final double price;
  final int? shopId;
  final int categoryId;
  final int active;
  final int isPrimary;
  final String imageUrl;
  final int isApproval;
  final int quantity;
  final String createdAt;
  final String updatedAt;
  final Details details;

  SubCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.shopId,
    required this.categoryId,
    required this.active,
    required this.isPrimary,
    required this.imageUrl,
    required this.isApproval,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      title: Map<String, String>.from(json['title']),
      description: Map<String, String>.from(json['description']),
      price: double.parse(json['price'].toString()),
      shopId: json['shop_id'],
      categoryId: json['category_id'],
      active: json['active'],
      isPrimary: json['is_primary'],
      imageUrl: json['image_url'],
      isApproval: json['is_approval'],
      quantity: json['quantity'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      details: Details.fromJson(json['details']),
    );
  }
}

class Details {
  final int deliveryBoyId;
  final int subCategoryId;
  final String price;
  final String totalQuantity;
  final String availableQuantity;

  Details({
    required this.deliveryBoyId,
    required this.subCategoryId,
    required this.price,
    required this.totalQuantity,
    required this.availableQuantity,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      deliveryBoyId: json['delivery_boy_id'],
      subCategoryId: json['sub_category_id'],
      price: json['price'],
      totalQuantity: json['total_quantity'],
      availableQuantity: json['available_quantity'],
    );
  }
}
