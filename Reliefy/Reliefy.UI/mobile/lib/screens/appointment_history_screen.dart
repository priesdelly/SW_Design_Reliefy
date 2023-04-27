import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/components/appointment_item.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/providers/appointment_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/utils/constant.dart';

import '../models/appointment.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  State<AppointmentHistoryScreen> createState() => _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  final AppointmentProvider _appointmentProvider = Get.find();
  final UserProvider _userProvider = Get.find();
  User? user;

  Future<List<Appointment>> getHistory() async {
    user = await _userProvider.getUserInfo();
    return _appointmentProvider.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPaddingContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder(
              future: getHistory(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (_, index) => AppointmentItem(appointment: snapshot.data!.elementAt(index), user: user,),
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
          )
        ],
      ),
    );
  }
}
