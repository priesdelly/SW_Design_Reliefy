import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/utils/loader.dart';
import 'package:mobile/utils/routes.dart';
import 'package:quiver/async.dart';
import '../components/button.dart';
import '../components/textbox_input.dart';

class TwoFaScreen extends StatefulWidget {
  const TwoFaScreen({super.key});

  @override
  State<TwoFaScreen> createState() => _TwoFaScreenState();
}

class _TwoFaScreenState extends State<TwoFaScreen> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final UserProvider userProvider = Get.find();

  final int _start = 30;
  int _current = 30;
  bool _isSendAgain = true;

  String errString = "";

  @override
  void initState() {
    userProvider.sendOtp();
    super.initState();
  }

  void startTimer() async {
    setState(() {
      _isSendAgain = false;
    });
    await userProvider.sendOtp();
    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: _start),
      const Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      setState(() {
        _isSendAgain = true;
      });
      sub.cancel();
    });
  }

  void submit() async {
    if (codeController.text.isEmpty) return;
    Loader.show();
    try {
      final result = await userProvider.checkOtp(codeController.text);
      if (result!.status == "success") {
        Get.offAllNamed(PageRoutes.conpleteInfo);
      } else {
        setState(() {
          errString = result.message!;
        });
      }
    } finally {
      Loader.hide();
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
                  Align(alignment: Alignment.center, child: SvgPicture.asset("assets/images/reading-side.svg", height: 200)),
                  const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Open email to find verification code.",
                    style: TextStyle(
                      // fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextboxInput(
                          controller: codeController,
                          hintText: "Verfiy code",
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Button(label: "Submit", onPressed: submit),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  _isSendAgain
                      ? TextButton(
                          onPressed: startTimer,
                          child: const Text(
                            "Send again",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Text("Send again in $_current"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    errString,
                    style: const TextStyle(color: Colors.red),
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
