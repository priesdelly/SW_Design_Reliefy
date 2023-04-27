import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_connect/connect.dart';

import '../utils/constant.dart';

class HttpProvider extends GetConnect {
  @override
  void onInit() {
    // allowAutoSignedCert = true;
    httpClient.baseUrl = kServerUrl;
    httpClient.timeout = const Duration(seconds: 120);

    httpClient.addAuthenticator<dynamic>((request) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final token = await currentUser.getIdToken();
        request.headers['Authorization'] = "Bearer $token";
      }
      request.headers['Connection'] = "Keep-Alive";
      return request;
    });

    // httpClient.addResponseModifier((request, response) {
    //   switch (response.statusCode) {
    //     case 401:
    //       FirebaseAuth.instance.signOut();
    //       break;
    //   }
    // });
  }
}
