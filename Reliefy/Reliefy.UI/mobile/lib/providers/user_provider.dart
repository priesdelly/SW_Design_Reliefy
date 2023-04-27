import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:get/instance_manager.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import 'package:mobile/models/response_message.dart';
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

    final uid = fireAuthController.getUid();
    if (uid == null) return null;
    final res = await get('/api/user/getUserInfo', query: {"uid": uid});
    final user = User.fromJson(res.body);
    await prefs.setString("user", jsonEncode(user));
    return user;
  }

  Future<List<User>?> getListDoctors() async {
    final res = await get<List<dynamic>?>('/api/user/getListDoctors');
    if (res.statusCode == 200) {
      return res.body?.map((e) => User.fromJson(e)).toList();
    }
    throw Exception(res.statusText);
  }

  Future<bool> sendOtp() async {
    final uid = fa.FirebaseAuth.instance.currentUser!.uid;
    final email = fa.FirebaseAuth.instance.currentUser!.email;
    final Map<String, dynamic> data = {"uid": uid, "email": email};
    final res = await post('/api/user/sendOtp', data);
    if (res.statusCode == 200) {
      return true;
    }
    throw Exception(res.statusText);
  }

  Future<ResponseMessage?> checkOtp(String code) async {
    final email = fa.FirebaseAuth.instance.currentUser!.email;
    Map<String, dynamic> data = {"email": email, "code": code};
    final res = await post('/api/user/checkOtp', data);
    if (res.statusCode == 200) {
      return ResponseMessage.fromJson(res.body);
    }
    throw Exception(res.statusText);
  }
}
