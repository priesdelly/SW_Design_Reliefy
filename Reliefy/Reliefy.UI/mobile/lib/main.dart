import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import 'package:mobile/providers/appointment_provider.dart';
import 'package:mobile/providers/available_time_provider.dart';
import 'package:mobile/providers/http_provider.dart';
import 'package:mobile/screens/_layout.dart';
import 'package:mobile/screens/complete_info_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/two_fa_screen.dart';
import 'package:mobile/utils/routes.dart';
import 'package:mobile/utils/palette.dart';
import 'models/user.dart';
import 'providers/user_provider.dart';
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

  Future<User?> _initial() {
    final FireAuthController authController = Get.find();
    authController.initialState();
    final UserProvider userProvider = Get.find();
    return userProvider.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
              if (snapshot.data != null && (snapshot.data!.isVerified == null || snapshot.data!.isVerified == false)) {
                return const TwoFaScreen();
              } else if (snapshot.data != null &&
                  (snapshot.data!.isCompleteInfo == null || snapshot.data!.isCompleteInfo == false)) {
                return const CompleteInfoScreen();
              } else {
                return const LayoutScreen();
              }
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
    Get.lazyPut(() => UserProvider());
    Get.lazyPut(() => AvailableTimeProvider());
    Get.lazyPut(() => AppointmentProvider());
  }
  @override
  void dependencies() {
    Get.put(HttpProvider());
    Get.put(FireAuthController());
    Get.put(UserProvider());
    Get.put(AvailableTimeProvider());
    Get.put(AppointmentProvider());
  }
}
