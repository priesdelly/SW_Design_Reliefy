import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/controllers/fireauth_controller.dart';
import '../components/textbox_input.dart';

class CompleteInfoScreen extends StatefulWidget {
  const CompleteInfoScreen({super.key});

  @override
  State<CompleteInfoScreen> createState() => CompleteInfoScreenState();
}

class CompleteInfoScreenState extends State<CompleteInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final FireAuthController authController = Get.find();

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneController = TextEditingController();

  String? validateEmpty(String? value) {
    return (value != null && value.isEmpty) ? '' : null;
  }

  void onSubmit() async {}

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
                  Align(alignment: Alignment.center, child: SvgPicture.asset("assets/images/clumsy.svg", height: 250)),
                  const Text("Complete infomation",
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
                          controller: firstnameController,
                          hintText: "Firstname",
                          validator: validateEmpty,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextboxInput(
                          controller: lastnameController,
                          hintText: "Lastname",
                          validator: validateEmpty,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextboxInput(
                          controller: phoneController,
                          hintText: "Phone number",
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
                            onPressed: onSubmit,
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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
