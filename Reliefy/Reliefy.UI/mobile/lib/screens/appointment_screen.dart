import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/components/appointment_item.dart';
import 'package:mobile/providers/appointment_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/utils/constant.dart';

import '../models/appointment.dart';
import '../models/user.dart';
import '../utils/routes.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentProvider _appointmentProvider = Get.find();
  final UserProvider _userProvider = Get.find();
  User? user;

  late Future<List<Appointment>> getList;
  late Future<User?> getUser;

  _AppointmentScreenState() {
    getUser = _userProvider.getUserInfo();
    getList = getUser.then((value) {
      user = value;
      return _appointmentProvider.getList();
    });
  }

  void refresh() {
    setState(() {
      getList = _appointmentProvider.getList();
    });
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
                FutureBuilder(
                  future: getList,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (_, index) => AppointmentItem(
                          appointment: snapshot.data!.elementAt(index),
                          cancelCallback: refresh,
                          user: user,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error occur"),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.all(50),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: getUser,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      final user = snapshot.data;
                      if (user!.userRoles!.first.role!.name == 'Patient') {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: kBlueLight.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(14)),
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
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
