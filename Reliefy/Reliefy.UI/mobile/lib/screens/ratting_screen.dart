import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/providers/appointment_provider.dart';
import 'package:mobile/utils/routes.dart';

import '../utils/constant.dart';
import '../utils/loader.dart';

// ignore: must_be_immutable
class RattingScreen extends StatelessWidget {
  late final String? _appointmentId;
  final AppointmentProvider _appointmentProvider = Get.find();
  double score = 0;

  RattingScreen({super.key}) {
    _appointmentId = Get.parameters["appointmentId"];
  }

  void onSubmit() async {
    try {
      Loader.show();
      await _appointmentProvider.review(_appointmentId!, score);
    } finally {
      Loader.hide();
      Get.offNamed(PageRoutes.home, parameters: {"index": "1"});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: kPaddingContainer, right: kPaddingContainer),
          child: Text("Review"),
        ),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const FaIcon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                score = rating;
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Button(
                label: "Submit review",
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
