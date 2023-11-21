import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/utils/Validator.dart';
import 'package:DeliveryBoyApp/utils/colors.dart';
import 'package:DeliveryBoyApp/utils/helper/commonview.dart';
import 'package:DeliveryBoyApp/utils/ui/logo.dart';
import 'package:DeliveryBoyApp/views/auth/Categories.dart';
import 'package:DeliveryBoyApp/views/auth/CategoryController.dart';
import 'package:DeliveryBoyApp/views/auth/shop_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import '../../api/api.dart';
import '../../controllers/AuthController.dart';
import '../../utils/TextUtils.dart';
import '../../utils/fonts.dart';
import '../../utils/helper/navigator.dart';
import '../../utils/navigator.dart';
import '../../utils/ui/textfeild.dart';
import '../AppScreen.dart';
import 'login/LoginScreen.dart';
import 'OTPVerificationScreen.dart';
import 'authControllernew.dart';
import 'd.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //ThemeData
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  //Text Field Editing Controller
  TextEditingController? mobile = TextEditingController();
  TextEditingController? carNumber = TextEditingController();
  TextEditingController? nameArabic = TextEditingController();
  TextEditingController? nameEnglish = TextEditingController();
  TextEditingController? nameAgencyArabic = TextEditingController();
  TextEditingController? nameAgencyEnglish = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  TextEditingController? profile = TextEditingController();
  TextEditingController? licence = TextEditingController();
  TextEditingController? carLicence = TextEditingController();

  int selectedCountryCode = 0;
  List<PopupMenuEntry<Object>>? countryList;
  List<dynamic> countryCode = TextUtils.countryCode;

  //Global Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formState = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  //Other Variables
  late bool isInProgress;
  bool showPassword = false;
  String contrycode = "962";

  //UI Variables

  File? profilePic;
  File? licencePic;
  File? car_license;

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        profilePic = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        profilePic = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageLicenseFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        licencePic = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  getImageLicenseFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        licencePic = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageCarFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        car_license = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  getImageCarFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        car_license = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  AuthControllerr authController = Get.put(AuthControllerr());

  List errorMessages = [];
  List cat = [];
  Categories? selectedCategory;
  ShopsModel? selectedShop;

  _handleRegister() async {
    await authController.registerUser(
      nameArabic: nameArabic!.text,
      password: password!.text,
      drivingLicense: licencePic,
      profilePic: profilePic,
      car: car_license,
      email: email!.text,
      agencyArabic: nameAgencyArabic!.text,
      agencyEnglish: nameAgencyArabic!.text,
      mobile: contrycode.toString() + mobile!.text,
      nameEnglish: nameArabic!.text,
      carNum: carNumber!.text,
      shopId: selectedShop == null ? '' : selectedShop!.id,
      categoryId: selectedCategory!.id,
    );
  }

  CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        return SafeArea(
          child: Scaffold(
              body: Form(
            key: formState,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                // LogoAsset(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Text(
                    Translator.translate("create_account").toUpperCase(),
                    style: boldPrimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showCountryPicker(
                            context: context,
                            //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                            exclude: <String>['KN', 'MF'],
                            favorite: <String>['SE'],
                            //Optional. Shows phone code before the country name.
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                contrycode = country.phoneCode;
                              });
                              log('Select country: $contrycode');
                            },
                            // Optional. Sets the theme for the country list picker.
                            countryListTheme: CountryListThemeData(
                              // Optional. Sets the border radius for the bottomsheet.
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              ),
                              // Optional. Styles the search field.
                              inputDecoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Start typing to search',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8)
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                              // Optional. Styles the text in the search field
                              searchTextStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: Text(contrycode,
                            style: const TextStyle(color: Colors.white)),
                      ),
                      Spacing.width(8),
                      Expanded(
                          child: CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (value.length != 9) {
                            return 'mobile number not eqiual 9 ';
                          }
                        },
                        hintText: 'mobile Number',
                        controller: mobile!,
                        prefixIconData: Icon(Icons.phone_android),
                        keyBoard: TextInputType.number,
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    keyBoard: TextInputType.emailAddress,
                    controller: email!,
                    hintText: Translator.translate("Email"),
                    prefixIconData: Icon(Icons.email_outlined),
                    onPrefixIconPress: () {
                      setState(() {});
                    },
                  ),
                ),
                // CustomTextField(
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return Translator.translate('Please enter your   Name English');
                //     }
                //     if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value!)) {
                //       return Translator.translate('please only character in English');
                //     }
                //   },
                //   keyBoard: TextInputType.text,
                //   controller: nameEnglish!,
                //   hintText: Translator.translate("name in English"),
                //   prefixIconData: Icon(Icons.person_2_outlined),
                //   onPrefixIconPress: () {
                //     setState(() {});
                //   },
                // ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Translator.translate(
                          'Please enter your shop Name Arabic');
                    }
                    if (!RegExp(r'^[؀-ۿ\s]+$').hasMatch(value!)) {
                      return Translator.translate(
                          'please only character in Arabic');
                    }
                  },
                  keyBoard: TextInputType.text,
                  controller: nameArabic!,
                  hintText: Translator.translate("name in arabic"),
                  prefixIconData: Icon(Icons.person_2_outlined),
                  onPrefixIconPress: () {
                    setState(() {});
                  },
                ),
                CustomTextField(
                  validator: (value) {
                    if (profilePic == null) {
                      return Translator.translate(
                          'Please enter your profilePic');
                    }
                  },
                  controller: profile!,
                  keyBoard: TextInputType.text,
                  prefixIconData: InkWell(
                    onTap: () {
                      showImagePicker(context);
                    },
                    child: Icon(Icons.image_outlined),
                  ),
                  readOnly: true,
                  press: () => showImagePicker(context),
                  hintText: profilePic != null
                      ? profilePic!.path.split('/').last
                      : Translator.translate("profile_pic"),
                ),
                CustomTextField(
                  validator: (value) {
                    if (licencePic == null) {
                      return Translator.translate(
                          'Please enter your licencePic');
                    }
                  },
                  controller: licence!,
                  keyBoard: TextInputType.text,
                  prefixIconData: InkWell(
                    onTap: () {
                      showImagePicker2(context);
                    },
                    child: Icon(Icons.image_outlined),
                  ),
                  readOnly: true,
                  press: () => showImagePicker2(context),
                  hintText: licencePic != null
                      ? licencePic!.path.split('/').last
                      : Translator.translate("licencePic"),
                ),
                Obx(() {
                  if (controller.isWaiting) {
                    return Text('mo');
                  }
                  if (controller.isError) {
                    return Text('g');
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      margin: Spacing.fromLTRB(24, 16, 24, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Color(0xffdcdee3), width: 1.5),
                      ),
                      padding: EdgeInsets.all(10),
                      child: DropdownButton<Categories>(
                        underline: Container(),
                        value: selectedCategory,
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: Colors.white,
                        hint: Text(
                            Translator.translate('please select category')),
                        // Set a default value if needed.
                        onChanged: (Categories? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            log(selectedCategory!.title!.en.toString());
                            log(selectedCategory!.id.toString());
                          });
                          // Handle the selected category.
                        },
                        items: controller.category
                            .map((category) => DropdownMenuItem<Categories>(
                                  value: category,
                                  child: Text(category!.title!.en),
                                ))
                            .toList(),
                      ));
                }),
                selectedCategory == null
                    ? Text('')
                    : selectedCategory!.id == 1
                        ? Obx(() {
                            if (controller.isWaiting) {
                              return Text('mo');
                            }
                            if (controller.isError) {
                              return Text('g');
                            }
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                margin: Spacing.fromLTRB(24, 16, 24, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(0xffdcdee3), width: 1.5),
                                ),
                                padding: EdgeInsets.all(10),
                                child: DropdownButton<ShopsModel>(
                                  underline: Container(),
                                  value: selectedShop,
                                  borderRadius: BorderRadius.circular(20),
                                  dropdownColor: Colors.white,
                                  hint: Text(Translator.translate(
                                      'please select shop')),
                                  // Set a default value if needed.
                                  onChanged: (ShopsModel? newValue) {
                                    setState(() {
                                      selectedShop = newValue!;
                                      log(selectedShop!.shopNameEn.toString());
                                    });
                                    // Handle the selected category.
                                  },
                                  items: controller.shops
                                      .map((shop) =>
                                          DropdownMenuItem<ShopsModel>(
                                            value: shop,
                                            child: Text(shop!.shopNameEn),
                                          ))
                                      .toList(),
                                ));
                          })
                        : Column(
                            children: [
                              // CustomTextField(
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return Translator.translate('Please enter your  agency  Name English');
                              //     }
                              //     if (!RegExp(r'^[a-zA-Z]+$')
                              //         .hasMatch(value!)) {
                              //       return Translator.translate('please only character in English');
                              //     }
                              //   },
                              //   keyBoard: TextInputType.text,
                              //   controller: nameAgencyEnglish!,
                              //   hintText: Translator.translate(
                              //       "agency name in English"),
                              //   prefixIconData: Icon(Icons.home_work_outlined),
                              //   onPrefixIconPress: () {
                              //     setState(() {});
                              //   },
                              // ),
                              CustomTextField(
                                validator: (value) {
                                  if (car_license == null) {
                                    return Translator.translate(
                                        'Please enter your car_license');
                                  }
                                },
                                controller: carLicence!,
                                keyBoard: TextInputType.text,
                                prefixIconData: InkWell(
                                  onTap: () {
                                    showImagePicker3(context);
                                  },
                                  child: Icon(Icons.image_outlined),
                                ),
                                readOnly: true,
                                press: () => showImagePicker3(context),
                                hintText: car_license != null
                                    ? car_license!.path.split('/').last
                                    : Translator.translate("car_license"),
                              ),
                              CustomTextField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return Translator.translate(
                                        'Please enter your agency Name Arabic');
                                  }
                                  if (!RegExp(r'^[؀-ۿ\s]+$').hasMatch(value!)) {
                                    return Translator.translate(
                                        'please only character in Arabic');
                                  }
                                },
                                keyBoard: TextInputType.text,
                                controller: nameAgencyArabic!,
                                hintText: Translator.translate(
                                    Translator.translate(
                                        "agency name in arabic")),
                                prefixIconData: Icon(Icons.home_work_outlined),
                                onPrefixIconPress: () {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Translator.translate(
                          'Please enter your car number');
                    }
                  },
                  keyBoard: TextInputType.text,
                  controller: carNumber!,
                  hintText: Translator.translate("Car Number"),
                  prefixIconData: Icon(Icons.onetwothree_outlined),
                  onPrefixIconPress: () {
                    setState(() {});
                  },
                ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Translator.translate(
                          'Please enter your  password');
                    }
                    if (value.length <= 8) {
                      return Translator.translate(
                          'password length at least 8 character');
                    }
                  },
                  keyBoard: TextInputType.text,
                  controller: password!,
                  isPassword: showPassword,
                  hintText: Translator.translate("password"),
                  prefixIconData: Icon(Icons.lock_outline),
                  onPrefixIconPress: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
                authController.erroeMsg.length == 0
                    ? Text('')
                    : Obx(() => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: authController.erroeMsg.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: authController.erroeMsg.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          authController.erroeMsg[index],
                                          softWrap: false,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Text(''),
                        )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                  child: CommonViews().createButton(
                    title: Translator.translate('Create account'),
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        _handleRegister();
                      }
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      DriverNavigator.of(context).push(LoginScreen());
                    },
                    child: Text(
                      Translator.translate("i_have_already_an_account"),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText2,
                          color: themeData.colorScheme.onBackground,
                          fontWeight: 500,
                          decoration: TextDecoration.underline),
                    )),
              ],
            ),
          )),
        );
      },
    );
  }

  void showMessage({String message = "Something wrong", Duration? duration}) {
    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(message,
            style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
                letterSpacing: 0.4, color: themeData.colorScheme.onPrimary)),
        backgroundColor: themeData.colorScheme.primary,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.image,
                            size: 60.0,
                            color: primaryColor,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        getImageFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: SizedBox(
                        child: Column(
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                              color: primaryColor,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        getImageFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  void showImagePicker2(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.image,
                            size: 60.0,
                            color: primaryColor,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        getImageLicenseFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: SizedBox(
                        child: Column(
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                              color: primaryColor,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        getImageLicenseFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  void showImagePicker3(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.image,
                            size: 60.0,
                            color: primaryColor,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        getImageCarFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: SizedBox(
                        child: Column(
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                              color: primaryColor,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        getImageCarFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  Future<void> registerUser() async {
    final registrationUrl = Uri.parse(
        'https://admin.wasiljo.com/public/api/v1/delivery-boy/register'); // Replace with your actual API URL

    // Define the user data as a map
    final userData = {
      '[data][deliveryBoy][name][en]': 'test5',
      "[data][deliveryBoy][name][ar]": 'تجرب5',
      'mobile': mobile!.text,
      'password': password!.text,
      'email': email!.text,
      'car_number': carNumber!.text,
      'category_id': '1',
      'shop_id': '1',
      'driving_license': licencePic!.path,
      'avatar_url': profilePic!.path,
    };

    try {
      final response = await http.post(
        registrationUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        print('User registered successfully');
        // You can handle the response data here if the server sends a response.
      } else {
        print('Failed to register user. Status code: ${response.statusCode}');
        print('Failed to register user. Status code: ${response.body}');
      }
    } catch (error) {
      print('Error registering user: $error');
    }
  }
}
// import 'dart:io';
//
// import 'package:DeliveryBoyApp/api/api_util.dart';
// import 'package:DeliveryBoyApp/controllers/AuthController.dart';
// import 'package:DeliveryBoyApp/models/MyResponse.dart';
// import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
// import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
// import 'package:DeliveryBoyApp/utils/Validator.dart';
// import 'package:DeliveryBoyApp/views/auth/Categories.dart';
// import 'package:DeliveryBoyApp/views/auth/CategoryController.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';
// import '../../AppTheme.dart';
// import '../../AppThemeNotifier.dart';
// import '../../utils/TextUtils.dart';
// import '../AppScreen.dart';
// import 'LoginScreen.dart';
// import 'OTPVerificationScreen.dart';
//
// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//
//   //ThemeData
//   late ThemeData themeData;
//   late CustomAppTheme customAppTheme;
//
//   //Text Field Editing Controller
//   TextEditingController? _numberController;
//   TextEditingController? _carNumberController;
//   TextEditingController? nameTFController;
//   TextEditingController? emailTFController;
//   TextEditingController? passwordTFController;
//   final GlobalKey _countryCodeSelectionKey = new GlobalKey();
//   int selectedCountryCode = 0;
//   List<PopupMenuEntry<Object>>? countryList;
//   List<dynamic> countryCode = TextUtils.countryCode;
//
//   //Global Keys
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = new GlobalKey<ScaffoldMessengerState>();
//
//   List<Shop>? shops;
//
//   List<Category>? categories;
//   //Other Variables
//   late bool isInProgress;
//   bool showPassword = false;
//   String contrycode ="962";
//   //UI Variables
//   OutlineInputBorder? allTFBorder;
//
//   int? categoryId;
//   int? shopId;
//
//   File? profilePic;
//   File? licencePic;
//
//   Category? selectedCategory;
//   Shop? selectedShop;
//
//
//   final picker = ImagePicker();
//
//   Future getImageFromGallery() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         profilePic = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future getImageLicenseFromGallery() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         licencePic = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getCategories();
//     isInProgress = false;
//     nameTFController = TextEditingController();
//     _carNumberController =   TextEditingController();
//     emailTFController = TextEditingController();
//     passwordTFController = TextEditingController();
//     _numberController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     nameTFController!.dispose();
//     emailTFController!.dispose();
//     passwordTFController!.dispose();
//     super.dispose();
//   }
//
//   _getCategories() async {
//     if (mounted) {
//       setState(() {
//         isInProgress = true;
//       });
//     }
//
//     MyResponse<List<Category>> myResponse =
//     await CategoryController.getAllCategory();
//
//     if (myResponse.success) {
//       print("main done12");
//       print(myResponse.data);
//       categories = myResponse.data;
//       /*   if(mainCategory!.isNotEmpty) {
//         _getMainSecondCategories(mainCategory!.first.id);
//       }*/
//
//       setState(() {
//
//       });
//
//     } else {
//       print("sub er");
//       ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
//       showMessage(message: myResponse.errorText);
//     }
//
//     if (mounted) {
//       setState(() {
//         isInProgress = false;
//       });
//     }
//   }
//
//
//   _handleRegister() async {
//     String name = nameTFController!.text;
//     String email = emailTFController!.text;
//     String password = passwordTFController!.text;
//     String mobile = contrycode +  _numberController!.text;
//     String carnumber = _carNumberController!.text;
//
//     if (name.isEmpty) {
//       showMessage(message: Translator.translate("please_fill_name"));
//     }
//     else   if (_numberController!.text.isEmpty) {
//       showMessage(message: Translator.translate("please_fill_mobile"));
//     }
//
//     else   if (_carNumberController!.text.isEmpty) {
//       showMessage(message: Translator.translate("please_fill_car_num"));
//     }
//     else if (password.isEmpty) {
//       showMessage(message: Translator.translate("please_fill_password"));
//     } else {
//       if (mounted) {
//         setState(() {
//           isInProgress = true;
//         });
//       }
//
//       dynamic response =
//       await AuthController.registerUser(name, email, password,"+" + mobile,selectedCategory,selectedShop,licencePic,profilePic,carnumber);
//
//       if(mounted) {
//         setState(() {
//           isInProgress = false;
//         });
//       }
//       AuthType authType = await AuthController.userAuthType();
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) => LoginScreen(fromRegister: true,),
//         ),
//       );
//       showMessage(message: Translator.translate("success_register"));
//
//       // if (authType == AuthType.VERIFIED) {
//       //   Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (BuildContext context) => LoginScreen(),
//       //     ),
//       //   );
//       //   showMessage(message: Translator.translate("success_register"));
//       // } else if (authType == AuthType.LOGIN) {
//       //   Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (BuildContext context) => OTPVerificationScreen(),
//       //     ),
//       //   );
//       // } else {
//       //  // ApiUtil.checkRedirectNavigation(context, response.responseCode);
//       //   showMessage(message: response.errorText.toString());
//       // }
//
//     }
//   }
//
//   _initUI() {
//     allTFBorder = OutlineInputBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(8),
//         ),
//         borderSide: BorderSide(color: customAppTheme.bgLayer4, width: 1.5));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppThemeNotifier>(
//       builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
//         int themeType = value.themeMode();
//         themeData = AppTheme.getThemeFromThemeMode(themeType);
//         customAppTheme = AppTheme.getCustomAppTheme(themeType);
//         _initUI();
//         return MaterialApp(
//             scaffoldMessengerKey: _scaffoldMessengerKey,
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.getThemeFromThemeMode(themeType),
//             home: Scaffold(
//                 key: _scaffoldKey,
//                 body: Container(
//                     color: customAppTheme.bgLayer1,
//                     child: ListView(
//                       padding: Spacing.top(120),
//                       children: <Widget>[
//                         Container(
//                           child: Image.asset(
//                             'assets/images/logo.png',
//                             // color: themeData.colorScheme.primary,
//                             width: 54,
//                             height: 54,
//                           ),
//                         ),
//                         Container(
//                           margin: Spacing.top(24),
//                           child: Center(
//                             child: Text(
//                               Translator.translate("create_account").toUpperCase(),
//                               style: AppTheme.getTextStyle(
//                                   themeData.textTheme.headline6,
//                                   color: themeData.colorScheme.onBackground,
//                                   fontWeight: 700,
//                                   letterSpacing: 0.5),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: Spacing.fromLTRB(24, 5, 24, 0),
//                           child: TextFormField(
//                             style: AppTheme.getTextStyle(
//                                 themeData.textTheme.bodyText1,
//                                 letterSpacing: 0.1,
//                                 color: themeData.colorScheme.onBackground,
//                                 fontWeight: 500),
//                             decoration: InputDecoration(
//                                 hintText: Translator.translate("name"),
//                                 hintStyle: AppTheme.getTextStyle(
//                                     themeData.textTheme.subtitle2,
//                                     letterSpacing: 0.1,
//                                     color: themeData.colorScheme.onBackground,
//                                     fontWeight: 500),
//                                 border: allTFBorder,
//                                 enabledBorder: allTFBorder,
//                                 focusedBorder: allTFBorder,
//                                 prefixIcon: Icon(
//                                   MdiIcons.accountOutline,
//                                   size: MySize.size22,
//                                 ),
//                                 isDense: true,
//                                 contentPadding: Spacing.zero),
//                             keyboardType: TextInputType.text,
//                             controller: nameTFController,
//                             textCapitalization: TextCapitalization.sentences,
//                           ),
//                         ),
//                         Container(
//                           margin: Spacing.fromLTRB(24, 24, 24, 0),
//
//                           // padding: Spacing.all(16),
//                           child: Column(
//                             children: <Widget>[
//                               Row(
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       showCountryPicker(
//                                         context: context,
//                                         //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
//                                         exclude: <String>['KN', 'MF'],
//                                         favorite: <String>['SE'],
//                                         //Optional. Shows phone code before the country name.
//                                         showPhoneCode: true,
//                                         onSelect: (Country country) {
//                                           setState(() {
//                                             contrycode = country.phoneCode;
//                                           });
//                                           print(
//                                               'Select country: ${country.displayName}');
//                                         },
//                                         // Optional. Sets the theme for the country list picker.
//                                         countryListTheme: CountryListThemeData(
//                                           // Optional. Sets the border radius for the bottomsheet.
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(40.0),
//                                             topRight: Radius.circular(40.0),
//                                           ),
//                                           // Optional. Styles the search field.
//                                           inputDecoration: InputDecoration(
//                                             labelText: 'Search',
//                                             hintText: 'Start typing to search',
//                                             prefixIcon:
//                                             const Icon(Icons.search),
//                                             border: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                 color: const Color(0xFF8C98A8)
//                                                     .withOpacity(0.2),
//                                               ),
//                                             ),
//                                           ),
//                                           // Optional. Styles the text in the search field
//                                           searchTextStyle: TextStyle(
//                                             color: Colors.green,
//                                             fontSize: 18,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child:  Text(contrycode),
//                                   ),
//                                   Spacing.width(8),
//                                   Expanded(
//                                     child: TextFormField(
//                                       style: AppTheme.getTextStyle(
//                                           themeData.textTheme.bodyText1,
//                                           letterSpacing: 0.1,
//                                           color: themeData
//                                               .colorScheme.onBackground,
//                                           fontWeight: 500),
//                                       decoration: InputDecoration(
//                                           hintText: Translator.translate(
//                                               "mobile_number"),
//                                           hintStyle: AppTheme.getTextStyle(
//                                               themeData.textTheme.subtitle2,
//                                               letterSpacing: 0.1,
//                                               color: themeData
//                                                   .colorScheme.onBackground,
//                                               fontWeight: 500),
//                                           border: allTFBorder,
//                                           enabledBorder: allTFBorder,
//                                           focusedBorder: allTFBorder,
//                                           prefixIcon: Icon(
//                                             MdiIcons.phone,
//                                             size: MySize.size22,
//                                           ),
//                                           isDense: true,
//                                           contentPadding: Spacing.zero),
//                                       keyboardType: TextInputType.number,
//                                       autofocus: false,
//                                       textCapitalization:
//                                       TextCapitalization.sentences,
//                                       controller: _numberController,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: Spacing.fromLTRB(24, 16, 24, 0),
//                           child: TextFormField(
//                             style: AppTheme.getTextStyle(
//                                 themeData.textTheme.bodyText1,
//                                 letterSpacing: 0.1,
//                                 color: themeData.colorScheme.onBackground,
//                                 fontWeight: 500),
//                             decoration: InputDecoration(
//                                 hintText: Translator.translate("email_address") +" "+Translator.translate("optional")  ,
//                                 hintStyle: AppTheme.getTextStyle(
//                                     themeData.textTheme.subtitle2,
//                                     letterSpacing: 0.1,
//                                     color:
//                                     themeData.colorScheme.onBackground,
//                                     fontWeight: 500),
//                                 border: allTFBorder,
//                                 enabledBorder: allTFBorder,
//                                 focusedBorder: allTFBorder,
//                                 prefixIcon: Icon(
//                                   MdiIcons.emailOutline,
//                                   size: MySize.size22,
//                                 ),
//                                 isDense: true,
//                                 contentPadding: Spacing.zero),
//                             keyboardType: TextInputType.emailAddress,
//                             controller: emailTFController,
//                           ),
//                         ),
//
//
//                         profilePic !=null ? Container(
//                             margin: Spacing.fromLTRB(24, 16, 24, 0),
//                             child: Image.file(profilePic!)
//                         ):Container(),
//
//
//
//
//                         Container(
//                             margin: Spacing.fromLTRB(24, 16, 24, 0),
//                             child: TextField(
//                                 readOnly: true,
//                                 onTap: () {
//                                   getImageFromGallery();
//                                 },
//                                 style: AppTheme.getTextStyle(
//                                     themeData.textTheme.bodyText1,
//                                     letterSpacing: 0.1,
//                                     color: themeData.colorScheme.onBackground,
//                                     fontWeight: 500),
//                                 decoration: InputDecoration(
//                                     labelText:profilePic!=null ?  profilePic!.path.split('/').last :Translator.translate("profile_pic")  ,
//                                     hintText: profilePic!=null ?  profilePic!.path.split('/').last :Translator.translate("profile_pic")  ,
//                                     hintStyle: AppTheme.getTextStyle(
//                                       themeData.textTheme.subtitle2,
//                                       letterSpacing: 0.1,
//                                       color:
//                                       themeData.colorScheme.onBackground,
//                                       fontWeight: 500,
//
//                                     ),
//                                     isDense: true,
//                                     suffixIcon: IconButton(
//                                       onPressed: () {
//                                         getImageFromGallery();
//                                       },
//                                       icon: Icon(Icons.photo_library),
//                                     ))
//                             )
//                         ),
//
//                         licencePic !=null ? Container(
//                             margin: Spacing.fromLTRB(24, 16, 24, 0),
//                             child: Image.file(licencePic!)
//                         ):Container(),
//
//                         SizedBox(height: 10,),
//
//                         Container(
//                             margin: Spacing.fromLTRB(24, 16, 24, 0),
//                             child: TextField(
//                                 readOnly: true,
//                                 onTap: () {
//
//                                   getImageLicenseFromGallery();
//
//                                 },
//                                 style: AppTheme.getTextStyle(
//                                     themeData.textTheme.bodyText1,
//                                     letterSpacing: 0.1,
//                                     color: themeData.colorScheme.onBackground,
//                                     fontWeight: 500),
//                                 decoration: InputDecoration(
//                                     labelText: licencePic!=null ?  licencePic!.path.split('/').last :Translator.translate("licence_pic")  ,
//                                     hintText: licencePic!=null ?  licencePic!.path.split('/').last :Translator.translate("licence_pic")  ,
//                                     hintStyle: AppTheme.getTextStyle(
//                                       themeData.textTheme.subtitle2,
//                                       letterSpacing: 0.1,
//                                       color:
//                                       themeData.colorScheme.onBackground,
//                                       fontWeight: 500,
//
//                                     ),
//                                     isDense: true,
//                                     suffixIcon: IconButton(
//                                       onPressed: () {
//                                         getImageLicenseFromGallery();
//                                       },
//                                       icon: Icon(Icons.photo_library),
//                                     ))
//                             )
//                         ),
//
//
//                         Container(
//                           margin: Spacing.fromLTRB(24, 16, 24, 0),
//                           child: TextFormField(
//                             style: AppTheme.getTextStyle(
//                                 themeData.textTheme.bodyText1,
//                                 letterSpacing: 0.1,
//                                 color: themeData.colorScheme.onBackground,
//                                 fontWeight: 500),
//                             decoration: InputDecoration(
//                                 hintText: Translator.translate("car_num")  ,
//                                 hintStyle: AppTheme.getTextStyle(
//                                     themeData.textTheme.subtitle2,
//                                     letterSpacing: 0.1,
//                                     color:
//                                     themeData.colorScheme.onBackground,
//                                     fontWeight: 500),
//                                 border: allTFBorder,
//                                 enabledBorder: allTFBorder,
//                                 focusedBorder: allTFBorder,
//                                 prefixIcon: Icon(
//                                   MdiIcons.numeric,
//                                   size: MySize.size22,
//                                 ),
//                                 isDense: true,
//                                 contentPadding: Spacing.zero),
//                             keyboardType: TextInputType.text,
//                             controller: _carNumberController,
//                           ),
//                         ),
//
//                         SizedBox(height: 10,),
//
//                         categories!=null ?    Container(
//                           height: MediaQuery.of(context).size.height * 0.06,
//                           margin: Spacing.fromLTRB(24, 16, 24, 0),
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,border: Border.all(color: Colors.grey, ),),
//                           padding: EdgeInsets.all(10),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<Category>(
//
//                               borderRadius: BorderRadius.circular(20),
//                               dropdownColor: Colors.white,
//                               isExpanded: true,
//                               value: selectedCategory,
//                               hint: Text(Translator.translate("type")),
//                               onChanged: (category) {
//                                 setState(() {
//                                   selectedCategory = category;
//                                   selectedShop=null;
//                                   shops = category!.shops;
//                                 });
//                               },
//                               items: categories!
//                                   .map((cat) => DropdownMenuItem(
//
//                                 value: cat,
//                                 child: Text(cat.title),
//                               ))
//                                   .toList(),
//                             ),
//                           ),
//                         ) : Container(),
//
//                         shops!=null &&  shops!.isNotEmpty ? Container(
//                           margin: Spacing.fromLTRB(24, 16, 24, 0),
//                           height: MediaQuery.of(context).size.height * 0.06,
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,border: Border.all(color: Colors.grey, ),),
//                           padding: EdgeInsets.all(10),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<Shop>(
//
//                               borderRadius: BorderRadius.circular(20),
//                               dropdownColor: Colors.white,
//                               isExpanded: true,
//                               value: selectedShop,
//                               hint: Text(Translator.translate("shop")),
//                               onChanged: (shop) {
//                                 setState(() {
//                                   selectedShop = shop;
//
//                                 });
//                               },
//                               items: shops!
//                                   .map((shop) => DropdownMenuItem(
//
//                                 value: shop,
//                                 child: Text(shop.name),
//                               ))
//                                   .toList(),
//                             ),
//                           ),
//                         ) : Container(),
//
//
//
//                         SizedBox(height: 10,),
//                         Container(
//                           margin: Spacing.fromLTRB(24, 16, 24, 0),
//                           child: TextFormField(
//                             obscureText: showPassword,
//                             style: AppTheme.getTextStyle(
//                                 themeData.textTheme.bodyText1,
//                                 letterSpacing: 0.1,
//                                 color: themeData.colorScheme.onBackground,
//                                 fontWeight: 500),
//                             decoration: InputDecoration(
//                               hintStyle: AppTheme.getTextStyle(
//                                   themeData.textTheme.subtitle2,
//                                   letterSpacing: 0.1,
//                                   color: themeData.colorScheme.onBackground,
//                                   fontWeight: 500),
//                               hintText: Translator.translate("password"),
//                               border: allTFBorder,
//                               enabledBorder: allTFBorder,
//                               focusedBorder: allTFBorder,
//                               prefixIcon: Icon(
//                                 MdiIcons.lockOutline,
//                                 size: 22,
//                               ),
//                               suffixIcon: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     showPassword = !showPassword;
//                                   });
//                                 },
//                                 child: Icon(
//                                   showPassword
//                                       ? MdiIcons.eyeOutline
//                                       : MdiIcons.eyeOffOutline,
//                                   size: MySize.size22,
//                                 ),
//                               ),
//                               isDense: true,
//                               contentPadding: Spacing.zero,
//                             ),
//                             controller: passwordTFController,
//                           ),
//                         ),
//                         Container(
//                             margin: Spacing.fromLTRB(24, 24, 24, 0),
//                             child: ElevatedButton(
//                               style: ButtonStyle(
//                                   padding: MaterialStateProperty.all(Spacing.xy(24,12)),
//                                   shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                                     borderRadius:  BorderRadius.circular(4),
//                                   ))
//                               ),
//                               onPressed: () {
//                                 if (!isInProgress) {
//                                   _handleRegister();
//                                 }
//                               },
//                               child: Stack(
//                                 clipBehavior: Clip.none, alignment: Alignment.center,
//                                 children: <Widget>[
//                                   Align(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       Translator.translate("create").toUpperCase(),
//                                       style: AppTheme.getTextStyle(
//                                           themeData.textTheme.bodyText2,
//                                           color: themeData
//                                               .colorScheme.onPrimary,
//                                           letterSpacing: 0.8,
//                                           fontWeight: 700),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     right: 16,
//                                     child: isInProgress
//                                         ? Container(
//                                       width: MySize.size16,
//                                       height: MySize.size16,
//                                       child: CircularProgressIndicator(
//                                           valueColor:
//                                           AlwaysStoppedAnimation<
//                                               Color>(
//                                               themeData
//                                                   .colorScheme
//                                                   .onPrimary),
//                                           strokeWidth: 1.4),
//                                     )
//                                         : ClipOval(
//                                       child: Container(
//                                         // color: themeData.colorScheme
//                                         //     .primaryVariant,
//                                         child: SizedBox(
//                                             width: MySize.size30,
//                                             height: MySize.size30,
//                                             child: Icon(
//                                               MdiIcons.arrowRight,
//                                               color: themeData
//                                                   .colorScheme
//                                                   .onPrimary,
//                                               size: MySize.size18,
//                                             )),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )),
//                         Center(
//                           child: Container(
//                             margin: Spacing.top(16),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => LoginScreen()));
//                               },
//                               child: Text(
//                                 Translator.translate("i_have_already_an_account"),
//                                 style: AppTheme.getTextStyle(
//                                     themeData.textTheme.bodyText2,
//                                     color: themeData.colorScheme.onBackground,
//                                     fontWeight: 500,
//                                     decoration: TextDecoration.underline),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                       ],
//                     ))));
//       },
//     );
//   }
//
//   void showMessage({String message = "Something wrong", Duration? duration}) {
//     if (duration == null) {
//       duration = Duration(seconds: 3);
//     }
//     _scaffoldMessengerKey.currentState!.showSnackBar(
//       SnackBar(
//         duration: duration,
//         content: Text(message,
//             style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
//                 letterSpacing: 0.4, color: themeData.colorScheme.onPrimary)),
//         backgroundColor: themeData.colorScheme.primary,
//         behavior: SnackBarBehavior.fixed,
//       ),
//     );
//   }
// }
