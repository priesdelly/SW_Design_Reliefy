import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import '../components/password_input.dart';
import '../components/textbox_input.dart';
import '../utils/alert.dart';
import '../utils/loader.dart';
import '../utils/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final FireAuthController authController = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? validateEmpty(String? value) {
    return (value != null && value.isEmpty) ? '' : null;
  }

  void onRegister() async {
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Alert.show(title: "Password and Confirm password not match");
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        Loader.show();
        await authController.signUp(email: emailController.text, password: passwordController.text);
        Get.offAllNamed(PageRoutes.home);
      } on ArgumentError catch (e) {
        Alert.show(title: e.invalidValue);
      } finally {
        if (context.mounted) {
          Loader.hide();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(alignment: Alignment.center, child: SvgPicture.asset("assets/images/sprinting.svg", height: 200)),
                  const Text("Register",
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
                          height: 15,
                        ),
                        PasswordInput(
                          controller: confirmPasswordController,
                          hintText: "Confirm Password",
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
                            onPressed: onRegister,
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
                                "Already joined Reliefy?",
                              ),
                              TextButton(
                                onPressed: () => Get.offNamed(PageRoutes.login),
                                style: ElevatedButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                child: const Text("Login"),
                              )
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
      ),
    );
  }
}
