import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/utils/alert.dart';
import 'package:mobile/utils/color.dart';

import '../components/password_input.dart';
import '../components/textbox_input.dart';
import '../controllers/fireauth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FireAuthController authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? validateEmpty(String? value) {
    return (value != null && value.isEmpty) ? '' : null;
  }

  void onLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        context.loaderOverlay.show();
        await authController.signInUsingEmailPassword(email: emailController.text, password: passwordController.text);
        Get.offAll(
          HomeScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      } on ArgumentError catch (e) {
        Alert.show(context: context, title: e.invalidValue);
      } finally {
        if (context.mounted) {
          context.loaderOverlay.hide();
        }
      }
    }
  }

  void onGoogleLogin() async {
    try {
      context.loaderOverlay.show();
      await authController.signInWithGoogle();
      Get.offAll(
        HomeScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    } on ArgumentError catch (e) {
      Alert.show(context: context, title: e.invalidValue);
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.center, child: SvgPicture.asset("assets/images/loving.svg", height: 200)),
                const Text("Login",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextboxInput(
                        controller: emailController,
                        hintText: "Email",
                        validator: validateEmpty,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      PasswordInput(
                        controller: passwordController,
                        hintText: "Password",
                        validator: validateEmpty,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                              (_) => Colors.transparent,
                            ),
                          ),
                          onPressed: onLogin,
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(20), child: Text("OR")),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kPowderBlueColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                (_) => Colors.transparent,
                              ),
                            ),
                            onPressed: onGoogleLogin,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/google.png"),
                                const SizedBox(width: 20),
                                const Text(
                                  "Login with Google",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "New to Reliefy?",
                            ),
                            TextButton(onPressed: () => {}, child: const Text("Register"))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
