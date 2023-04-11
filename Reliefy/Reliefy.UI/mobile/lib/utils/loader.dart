import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loader {
  static BuildContext? currentContext;

  static void show() {
    final context = Get.key.currentContext;
    if (context == null) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      routeSettings: const RouteSettings(name: "loading"),
      builder: (BuildContext context) {
        currentContext = context;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  static void hide() {
    if (currentContext != null) {
      final route = ModalRoute.of(currentContext!);
      Navigator.removeRoute(currentContext!, route!);
    }
  }
}
