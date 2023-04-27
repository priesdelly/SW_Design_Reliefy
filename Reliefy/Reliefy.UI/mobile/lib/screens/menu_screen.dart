import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import 'package:mobile/providers/user_provider.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});
  final FireAuthController _authController = Get.find();
  final UserProvider _userProvider = Get.find();

  void logout() async {
    await _authController.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _userProvider.getUserInfo(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello : ${snapshot.data!.firstname!} ${snapshot.data!.lastname!}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'You are : ${snapshot.data!.userRoles!.first.role!.name!}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: logout,
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
