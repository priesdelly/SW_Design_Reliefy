import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/utils/pages.dart';
import 'package:mobile/utils/palette.dart';
import 'firebase_options.dart';
import '../utils/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authController = Get.put(FireAuthController());

  Future<User?> _initialFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: pages,
      title: 'Reliefy',
      theme: ThemeData(
        primarySwatch: Palette.kMainTheme,
      ),
      home: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: FutureBuilder(
          future: _initialFirebase(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return LoaderOverlay(child: HomeScreen());
            } else if (!snapshot.hasData) {
              return const LoaderOverlay(child: LoginScreen());
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
