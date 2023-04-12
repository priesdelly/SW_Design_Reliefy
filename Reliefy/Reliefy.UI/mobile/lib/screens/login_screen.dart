import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/utils/alert.dart';
import 'package:mobile/utils/constant.dart';
import 'package:mobile/utils/routes.dart';
import '../components/password_input.dart';
import '../components/textbox_input.dart';
import '../controllers/fireauth_controller.dart';
import '../utils/loader.dart';

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
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Alert.show(title: "Please fill email and password");
    }
    if (_formKey.currentState!.validate()) {
      try {
        Loader.show();
        await authController.signInUsingEmailPassword(email: emailController.text, password: passwordController.text);
        Get.offAllNamed(PageRoutes.home);
      } on ArgumentError catch (e) {
        Alert.show(title: e.invalidValue);
      } finally {
        Loader.hide();
      }
    }
  }

  void onGoogleLogin() async {
    try {
      Loader.show();
      await authController.signInWithGoogle();
      Get.offAllNamed(PageRoutes.home);
    } on ArgumentError catch (e) {
      Alert.show(title: e.invalidValue);
    } finally {
      if (context.mounted) {
        Loader.hide();
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
                      Button(label: "Login", onPressed: onLogin),
                      const Padding(padding: EdgeInsets.all(20), child: Text("OR")),
                      Button(
                          backgroundColor: kPowderBlueColor,
                          onPressed: onGoogleLogin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/images/google.png"),
                              const Text(
                                "Login with Google",
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox()
                            ],
                          )),
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
                            TextButton(onPressed: () => Get.offNamed(PageRoutes.register), child: const Text("Register"))
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
