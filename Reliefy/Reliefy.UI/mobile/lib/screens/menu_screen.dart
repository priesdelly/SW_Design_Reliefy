import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/controllers/fireauth_controller.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});
  final FireAuthController authController = Get.find();

  void logout() async {
    await authController.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(onPressed: logout, child: const Text("Logout")),
    );
  }
}
