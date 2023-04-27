import 'dart:convert';

import 'package:get/instance_manager.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'http_provider.dart';

class UserProvider extends HttpProvider {
  Future<User?> createUser({
    required String uid,
    required String email,
    required String signInType,
  }) async {
    Map data = {"uid": uid, "email": email, "SignInType": signInType};
    final res = await post('/api/user/createUser', data);
    if (res.statusCode == 200) {
      final user = User.fromJson(res.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user", jsonEncode(user));
      return user;
    }
    throw Exception(res.statusText);
  }

  Future<User?> getUserInfo() async {
    final FireAuthController fireAuthController = Get.find();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    final uid = fireAuthController.getUid();
    if (uid == null) return null;
    if (userJson == null) {
      final res = await get('/api/user/getUserInfo', query: {"uid": uid});
      final user = User.fromJson(res.body);
      await prefs.setString("user", jsonEncode(user));
      return user;
    }
    return User.fromJson(jsonDecode(userJson));
  }

  Future<List<User>?> getListDoctors() async {
    final res = await get<List<dynamic>?>('/api/user/getListDoctors');
    if (res.statusCode == 200) {
      return res.body?.map((e) => User.fromJson(e)).toList();
    }
    throw Exception(res.statusText);
  }
}
