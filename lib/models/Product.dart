import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/utils/TextUtils.dart';
import 'package:flutter/material.dart';
import '../AppTheme.dart';
import '../api/currency_api.dart';
import '../services/AppLocalizations.dart';
import 'Category.dart';
import 'ProductImage.dart';
import 'ProductItem.dart';
import 'Shop.dart';

class Product {
  int id, categoryId, shopId;
  String? name;
  String? description;
  double rating;
  int totalRating;
  int offer;
  bool isFavorite;
  Category? category;
  Shop? shop;
  List<ProductItem>? productItems;
  List<ProductImage>? productImages;


  Product(
      this.id,
      this.categoryId,
      this.shopId,
      this.name,
      this.description,
      this.rating,
      this.totalRating,
      this.offer,
      this.isFavorite,
      this.category,
      this.shop,
      this.productItems,
      this.productImages,);

  static Product fromJson(Map<String, dynamic> jsonObject) {
    int id = int.parse(jsonObject['id'].toString());
    int categoryId = int.parse(jsonObject['category_id'].toString());
    int shopId = int.parse(jsonObject['shop_id'].toString());
    String? name = jsonObject['name'];
    String? description = jsonObject['description'];
    int offer = int.parse(jsonObject['offer'].toString());
    double rating = double.parse(jsonObject['rating'].toString());
    int totalRating = int.parse(jsonObject['total_rating'].toString());
    bool isFavorite =
    TextUtils.parseBool(jsonObject['is_favorite'].toString());

    Category? category;
    if (jsonObject['category'] != null)
      category = Category.fromJson(jsonObject['category']);

    Shop? shop;
    if (jsonObject['shop'] != null) shop = Shop.fromJson(jsonObject['shop']);

    List<ProductItem>? productItems;
    if(jsonObject['product_items']!=null)
      productItems = ProductItem.getListFromJson(jsonObject['product_items']);

    List<ProductImage>? productImages;
    if (jsonObject['product_images'] != null)
      productImages =
          ProductImage.getListFromJson(jsonObject['product_images']);

    return Product(id, categoryId, shopId, name, description, rating, totalRating, offer, isFavorite, category, shop,productItems, productImages);
  }

  static List<Product> getListFromJson(List<dynamic> jsonArray) {
    List<Product> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(Product.fromJson(jsonArray[i]));
    }
    return list;
  }


  @override
  String toString() {
    return 'Product{id: $id, categoryId: $categoryId, shopId: $shopId, name: $name, description: $description, rating: $rating, totalRating: $totalRating, offer: $offer, isFavorite: $isFavorite, category: $category, shop: $shop, productItems: $productItems, productImages: $productImages}';
  }

  static Text getTextFromQuantity(int quantity, TextStyle style, ThemeData themeData,CustomAppTheme customAppTheme){
    Color color;
    String text;
    if(quantity>8){
      color = themeData.colorScheme.onBackground;
      text = Translator.translate("in_stock");
    }else if(quantity>4){
      color = customAppTheme.colorInfo;
      text = Translator.translate("few_items_available");
    }else if(quantity>0){
      color = customAppTheme.colorError;
      text= Translator.translate("only")+ " " +quantity.toString()+ " " + Translator.translate("items_available");
    }else{
      color = customAppTheme.colorError;
      text=Translator.translate("stock_out");
    }

    return Text(text,style: style.copyWith(color: color),);
  }

  static Widget offerTextWidget(
      {double? originalPrice,
        int? offer,
        ThemeData? themeData,
        CustomAppTheme? customAppTheme,
        double fontSize = 18}) {
    if (offer == 0) {
      return Text(CurrencyApi.getSign(afterSpace: true) + originalPrice.toString(),
          style: AppTheme.getTextStyle(themeData!.textTheme.caption,
              color: themeData.colorScheme.onBackground,
              fontSize: fontSize,
              fontWeight: 600,
              letterSpacing: 0,
              wordSpacing: -1));
    } else {
      double discountedPrice = getOfferedPrice(originalPrice!, offer!);

      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(CurrencyApi.getSign(afterSpace: true) +  CurrencyApi.doubleToString(discountedPrice),
              style: AppTheme.getTextStyle(themeData!.textTheme.caption,
                  color: themeData.colorScheme.onBackground,
                  fontWeight: 600,
                  fontSize: fontSize, letterSpacing: 0.2, height: 0),
            ),
            Container(
              margin: Spacing.left(4),
              child: Text( CurrencyApi.getSign(afterSpace: true) +  CurrencyApi.doubleToString(originalPrice),
                  style: AppTheme.getTextStyle(themeData.textTheme.caption,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 500,
                      fontSize: fontSize * 0.6,
                      letterSpacing: 0,
                      wordSpacing: -1,height: 0,muted: true,
                      decoration: TextDecoration.lineThrough)),
            ),
          ],
        ),
      );
    }
  }


  static double getOfferedPrice(double originalPrice,int offer){
    return originalPrice * (1 - offer / 100);
  }



  static String getPlaceholderImage(){
    return './assets/images/placeholder/no-product-image.png';
  }




}
