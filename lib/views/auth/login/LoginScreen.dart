import 'package:DeliveryBoyApp/custom_bakage.dart';
import 'package:DeliveryBoyApp/views/auth/RegisterScreen.dart';
import 'package:DeliveryBoyApp/views/auth/authControllernew.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends GetView<AuthControllerr> {
  @override
  Widget build(BuildContext context) {
    AuthControllerr controller = Get.put(AuthControllerr());
    return Scaffold(
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: Spacing.top(150),
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                  child: Text(
                    Translator.translate("Sign in"),
                    style: boldPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Spacing.width(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showCountryPicker(
                        context: context,
                        exclude: <String>['KN', 'MF'],
                        favorite: <String>['SE'],
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          controller.countryCode.value = country.phoneCode;
                          log('Select country: $controller.countryCode');
                        },
                        countryListTheme: CountryListThemeData(
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
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    child: Text(controller.countryCode.value,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  Spacing.width(8),
                  Expanded(
                      child: CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Translator.translate(
                            'Please enter your mobile number');
                      }

                      return null;
                    },
                    hintText: Translator.translate('mobile Number'),
                    controller: controller.numberController,
                    prefixIconData: Icon(Icons.phone_android),
                    keyBoard: TextInputType.number,
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Translator.translate('Please enter your  password');
                }
                if (value.length <= 8) {
                  return Translator.translate(
                      'password length at least 8 character');
                }
                return null;
              },
              keyBoard: TextInputType.text,
              controller: controller.passwordTFController,
              isPassword: controller.showPassword.value,
              hintText: Translator.translate("password"),
              prefixIconData: Icon(Icons.lock_outline),
              onPrefixIconPress: () {
                controller.showPassword.value = !controller.showPassword.value;
              },
            ),
            // TextButton(
            //   style: const ButtonStyle(alignment: Alignment.bottomRight),
            //   onPressed: () {},
            //   child: Text(
            //     "${Translator.translate("forget password ?")} ",
            //   ),
            // ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  controller.erroeText.value,
                  style: const TextStyle(
                    color: Colors.red,
                    overflow: TextOverflow.ellipsis,
                  ),
                  softWrap: false,
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  log(controller.numberController.text);
                  log(controller.passwordTFController.text);
                  if (controller.formKey.currentState!.validate()) {
                    controller.loginUser(
                        controller.countryCode.toString() +
                            controller.numberController.text,
                        controller.passwordTFController.text);
                  }
                },
                child: Text(
                  Translator.translate("Sign in"),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: Spacing.top(16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Translator.translate("Don't have an Account?"),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        Translator.translate("SignUp"),
                        style: basicPrimary,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
