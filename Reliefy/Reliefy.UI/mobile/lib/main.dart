import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import 'package:mobile/providers/http_provider.dart';
import 'package:mobile/screens/_layout.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/utils/routes.dart';
import 'package:mobile/utils/palette.dart';
import 'controllers/user_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<User?> _initial() async {
    final FireAuthController authController = Get.find();
    authController.initialState();
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: PageRoutes.home,
      getPages: pages,
      title: 'Reliefy',
      theme: ThemeData(
        primarySwatch: Palette.kMainTheme,
        fontFamily: "IBMPlexSansThai",
      ),
      navigatorKey: Get.key,
      initialBinding: Bind(),
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: FutureBuilder(
          future: _initial(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return const LayoutScreen();
            } else if (!snapshot.hasData) {
              return const LoginScreen();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class Bind extends Bindings {
  Bind() {
    Get.lazyPut(() => HttpProvider());
    Get.lazyPut(() => FireAuthController());
    Get.lazyPut(() => UserController());
  }
  @override
  void dependencies() {}
}
