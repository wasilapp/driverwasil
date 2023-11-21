// import 'package:DeliveryBoyApp/controllers/category_new.dart';
// import 'package:DeliveryBoyApp/custom_bakage.dart';
// import 'package:DeliveryBoyApp/models/category_news.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
//
//
// class CategoryDropdown extends StatefulWidget {
//   static var id ;
//   @override
//   _CategoryDropdownState createState() => _CategoryDropdownState();
//
// }
//
// class _CategoryDropdownState extends State<CategoryDropdown> {
//
//   TextEditingController? nameAgencyArabic = TextEditingController();
//   TextEditingController? nameAgencyEnglish = TextEditingController();
//   List<CategoriesModel> _categories = [];
//   CategoriesModel ?_selectedCategory;
//
//   List<dynamic> categories = [];
//   List<dynamic> shops = [];
//   @override
//   void initState() {
//     super.initState();
//     // Fetch categories when the widget is created
//     fetchCategories();
//   }
//
//   Future<void> fetchCategories() async {
//     final categoryService = AllCategoriesService();
//     final categories = await categoryService.getAllCategory();
//     setState(() {
//       _categories = categories;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment:CrossAxisAlignment.stretch ,
//         children: [
//           Container( margin: Spacing.fromLTRB(24, 16, 24, 0),
//
//             decoration: BoxDecoration(
//                 border: Border.all(color: Color(0xffdcdee3), width: 1.5)),
//
//             child:
//             DropdownButton<CategoriesModel>(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//
//               hint: Text('Select Category'),
//               underline: Container(),
//
//               dropdownColor: backgroundColor,
//
//               value: _selectedCategory,
//               onChanged: (value) {
//
//                 setState(() {
//                   _selectedCategory = value!;
//                   CategoryDropdown.id=_selectedCategory!.id;
//                 });
//                 print(_selectedCategory!.title!.en);
//               },
//               items: _categories.map((CategoriesModel category) {
//                 return DropdownMenuItem<CategoriesModel>(
//                   value: category,
//                   child: Text('${category.title!.en}'), // Display the English title
//                 );
//               }).toList(),
//             ),
//
//           ),
//
//           // _selectedCategory!.title!.en=="Gas Service"?
//           //
//           // Column(
//           //   children: [
//           //     CustomTextField(
//           //       validator: (value) {
//           //         if (value == null || value.isEmpty) {
//           //
//           //           return 'Please enter your   Agency English';
//           //         }
//           //         if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!)) {
//           //           return 'please only character in English';
//           //         }
//           //       },
//           //       keyBoard: TextInputType.text,
//           //       controller: nameAgencyEnglish!,
//           //       hintText: Translator.translate(" Agency name in English"),
//           //       prefixIconData: Icon(Icons.store_mall_directory_outlined),
//           //       onPrefixIconPress: () {
//           //         setState(() {});
//           //       },
//           //     ),
//           //     CustomTextField(
//           //       validator: (value) {
//           //         if (value == null || value.isEmpty) {
//           //           return 'Please enter your Agency Name Arabic';
//           //         }
//           //         if (!RegExp(r'^[؀-ۿ\s]+$').hasMatch(value!)) {
//           //           return 'please only character in Arabic';
//           //         }
//           //       },
//           //       keyBoard: TextInputType.text,
//           //       controller: nameAgencyArabic!,
//           //       hintText: Translator.translate("Agency name in arabic"),
//           //       prefixIconData: Icon(Icons.store_mall_directory_outlined),
//           //       onPrefixIconPress: () {
//           //         setState(() {});
//           //       },
//           //     ),
//           //   ],
//           // ) :Container(),
//         ]);
//
//   }
// }
// class ShopDropdown extends StatefulWidget {
//   @override
//   _ShopDropdownState createState() => _ShopDropdownState();
// }
//
// class _ShopDropdownState extends State<ShopDropdown> {
//   List<Map<String, dynamic>> shops = []; // List to store shop data
//   String selectedShop=''; // Variable to store the selected shop
//
//   @override
//   void initState() {
//     super.initState();
//     fetchShops();
//   }
//
//   Future<void> fetchShops() async {
//     try {
//       // Make a GET request to the API URL
//       final response = await Dio().get("https://admin.wasiljo.com/public/api/v1/delivery-boy/categories");
//
//       // Check if the response status code is 200 (OK)
//       if (response.statusCode == 200) {
//         // Extract the data from the response
//         List<dynamic> categories = response.data['data']['categories'];
//
//         // Find the category with id=1
//         var categoryWithId1 = categories.firstWhere((category) => category['id'] == 1, orElse: () => null);
//
//         if (categoryWithId1 != null) {
//           shops = List<Map<String, dynamic>>.from(categoryWithId1['shops']);
//         }
//
//         setState(() {});
//       } else {
//         // Handle error
//         print("Failed to fetch data");
//       }
//     } catch (e) {
//       // Handle error
//       print("Exception: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Dropdown button to select a shop
//         DropdownButton<String>(
//           value: selectedShop,
//           onChanged: ( newValue) {
//             setState(() {
//               selectedShop = newValue!;
//             });
//           },
//           items: shops.map((shop) {
//             return DropdownMenuItem<String>(
//               value: shop['name']['en'], // Display the English shop name
//               child: Text(shop['name']['en']), // Display the English shop name
//             );
//           }).toList(),
//         ),
//         // Display the selected shop
//         Text("Selected Shop: $selectedShop"),
//       ],
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text("Shop Dropdown Example"),
//       ),
//       body: ShopDropdown(),
//     ),
//   ));
// }
