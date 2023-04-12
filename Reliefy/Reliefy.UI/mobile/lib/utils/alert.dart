import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alert {
  static Future show({required String title, String? content}) {
    final context = Get.key.currentContext;
    if (context == null) return Future(() => null);
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
