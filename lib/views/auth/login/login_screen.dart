import 'package:DeliveryBoyApp/views/auth/login/login_binding.dart';
import 'package:DeliveryBoyApp/views/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenView extends GetView<LoginController> {
  const LoginScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(controller.data),
          TextButton(
              onPressed: () {
                Get.to(() => LoginScreenView(),binding: LoginBinding());
              },
              child: Text(controller.data)),
        ],
      ),
    );
  }
}
