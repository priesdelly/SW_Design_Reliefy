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
      return User.fromJson(res.body);
    }
    throw Exception(res.statusText);
  }

  Future<List<User>?> getListDoctors() async {
    final res = await get<List<dynamic>?>('/api/user/getListDoctors');
    if (res.statusCode == 200) {
      return res.body?.map((e) => User.fromJson(e)).toList();
    }
    throw Exception("Error");
  }
}
