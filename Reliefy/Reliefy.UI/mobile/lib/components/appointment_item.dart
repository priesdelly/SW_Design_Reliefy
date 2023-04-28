import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/providers/appointment_provider.dart';
import 'package:mobile/utils/constant.dart';
import 'package:mobile/utils/routes.dart';
import '../models/appointment.dart';
import '../models/user.dart';

class AppointmentItem extends StatelessWidget {
  final Appointment appointment;
  final User? user;
  final void Function()? cancelCallback;
  final RxBool _isLoading = false.obs;
  AppointmentItem({super.key, required this.appointment, this.cancelCallback, this.user});

  String getName() {
    if (user != null && user!.userRoles!.first.role!.name == 'Doctor') {
      return '${appointment.patient?.firstname} ${appointment.patient?.lastname}';
    } else {
      return '${appointment.doctor?.firstname} ${appointment.doctor?.lastname}';
    }
  }

  void cancel() async {
    try {
      final AppointmentProvider appointmentProvider = Get.find();
      _isLoading.value = true;
      await appointmentProvider.cancel(appointment.id!);
      cancelCallback!();
    } finally {
      _isLoading.value = false;
    }
  }

  Widget buttonActionBuild() {
    if ((appointment.status == 2 || appointment.status == 3) &&
        (appointment.startTime!.compareTo(DateTime.now().toUtc()) > 0 &&
            appointment.endTime!.compareTo(DateTime.now().toUtc()) < 0)) {
      return Button(
        onPressed: () => Get.toNamed(PageRoutes.chat, parameters: {
          "appointmentId": appointment.id!,
          "doctorId": appointment.doctorId!,
          "patientId": appointment.patientId!
        }),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("Chat", style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: FaIcon(FontAwesomeIcons.comment, color: Colors.white),
            ),
          ],
        ),
      );
    } else if (appointment.status == 2 && (DateTime.now().toUtc().compareTo(appointment.startTime!) < 0)) {
      return Button(
          onPressed: cancel,
          backgroundColor: Colors.white,
          borderColor: Colors.black,
          height: 45,
          child: Obx(
            () => Row(
              mainAxisAlignment: _isLoading.value ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: !_isLoading.value
                  ? const [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Cancel", style: TextStyle(color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: FaIcon(FontAwesomeIcons.xmark, color: Colors.black),
                      ),
                    ]
                  : [const Center(child: CircularProgressIndicator())],
            ),
          ));
    } else if (appointment.status == 1) {
      return const Text("Canceled");
    } else {
      return Row(
        children: [
          Expanded(
            child: Button(
              onPressed: () => Get.toNamed(PageRoutes.chat, parameters: {
                "appointmentId": appointment.id!,
                "doctorId": appointment.doctorId!,
                "patientId": appointment.patientId!,
                "isLocked": "true",
              }),
              height: 45,
              backgroundColor: Colors.grey.shade600,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("View", style: TextStyle(color: Colors.white)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: FaIcon(FontAwesomeIcons.clockRotateLeft, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          (user != null && user!.userRoles!.first.role!.name == 'Patient' && appointment.score == null)
              ? Expanded(
                  child: Button(
                    onPressed: () => Get.toNamed(PageRoutes.ratting, parameters: {
                      "appointmentId": appointment.id!,
                    }),
                    height: 45,
                    backgroundColor: Colors.grey.shade600,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Ratting", style: TextStyle(color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: FaIcon(FontAwesomeIcons.star, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [
          BoxShadow(
              color: kBlueLight.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 1), blurStyle: BlurStyle.outer),
        ]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: kSecondaryColor),
                    child: const FaIcon(
                      FontAwesomeIcons.calendar,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getName(), style: const TextStyle(fontSize: 20)),
                    Row(
                      children: [
                        Chip(
                            label: Text(DateFormat('dd/MM/yyyy').format(appointment.startTime!.toLocal())),
                            backgroundColor: kBlueLight),
                        const SizedBox(
                          width: 10,
                        ),
                        Chip(
                            label: Text(
                                "${DateFormat('HH:mm').format(appointment.startTime!.toLocal())} - ${DateFormat('HH:mm').format(appointment.endTime!.toLocal())}"),
                            backgroundColor: kBlueLight),
                      ],
                    ),
                    buttonActionBuild()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
