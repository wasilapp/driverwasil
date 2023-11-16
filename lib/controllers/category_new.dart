//
// import 'package:DeliveryBoyApp/api/api.dart';
// import 'package:DeliveryBoyApp/models/category_news.dart';
//
//
//
// class AllCategoriesService {
//   Future<List <CategoriesModel>> getAllCategory() async {
//     Map<String,dynamic> data =
//     await Api().get(url: Api.BASE_URL+'api/v1/delivery-boy/categories');
//     List<dynamic> category=data['data']['categories'];
//     print("*********************category******************************");
//     print(category);
//     List<CategoriesModel> CategoriesList = [];
//     for (int i = 0; i < category.length; i++) {
//       CategoriesList.add(
//         CategoriesModel.fromJson(category[i]),
//       );
//     }
//     return CategoriesList;
//   }
// }