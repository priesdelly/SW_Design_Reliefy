import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/components/appointment_item.dart';
import 'package:mobile/utils/constant.dart';
import 'package:mobile/providers/user_provider.dart';

import '../utils/routes.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final UserProvider userProvider = Get.find();

  @override
  void initState() {
    userProvider.testGet();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPaddingContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Upcoming",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, color: kSecondaryColor),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < 3; i++) AppointmentItem(),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: kBlueLight.withOpacity(0.4)), borderRadius: BorderRadius.circular(14)),
                    height: 70,
                    child: TextButton(
                      onPressed: () => {},
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((_) => Colors.transparent),
                      ),
                      child: TextButton(
                        onPressed: () => Get.toNamed(PageRoutes.createAppointment),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(FontAwesomeIcons.plus),
                            SizedBox(width: 10),
                            Text(
                              "Make new appointment",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
