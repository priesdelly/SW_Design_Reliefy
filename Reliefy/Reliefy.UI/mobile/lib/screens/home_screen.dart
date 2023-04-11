import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/controllers/fireauth_controller.dart';

class HomeScreen extends StatelessWidget {
  final FireAuthController authController = Get.find();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    authController.initialState();
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () async => await authController.signOut(),
        child: Text("Signout"),
      )),
    );
  }
}
