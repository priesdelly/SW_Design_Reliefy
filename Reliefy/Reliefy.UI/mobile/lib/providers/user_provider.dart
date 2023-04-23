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
    return null;
  }

  Future<String?> testGet() async {
    final res = await get('/api/appointment');
    return res.body;
  }
}
