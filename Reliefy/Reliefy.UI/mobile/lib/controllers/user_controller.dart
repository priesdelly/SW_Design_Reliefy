import 'package:get/get_connect/connect.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/providers/http_provider.dart';

class UserController {
  final HttpProvider http = Get.find();

  UserController();

  Future<User?> createUser({
    required String uid,
    required String email,
    required String signInType,
  }) async {
    Map data = {"uid": uid, "email": email, "SignInType": signInType};
    final res = await http.post('/api/user/createUser', data);
    if (res.statusCode == 200) {
      return User.fromJson(res.body);
    }
    return null;
  }

  Future<String?> testGet() async {
    final res = await http.get('/api/appointment');
    print(res.statusCode);
    print(res.bodyString);
    return res.body;
  }
}
