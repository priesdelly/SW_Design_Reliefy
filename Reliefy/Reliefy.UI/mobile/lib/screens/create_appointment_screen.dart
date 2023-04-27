import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/components/select_appointment_date.dart';
import 'package:mobile/components/select_appointment_doctor.dart';
import 'package:mobile/models/available_times.dart';
import 'package:mobile/providers/appointment_provider.dart';
import 'package:mobile/providers/available_time_provider.dart';
import 'package:mobile/utils/alert.dart';
import 'package:mobile/utils/loader.dart';
import '../models/user.dart';
import '../utils/constant.dart';
import '../utils/routes.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() => _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  bool showDate = true;

  final AvailableTimeProvider availableTimeProvider = Get.find();
  final AppointmentProvider appointmentProvider = Get.find();

  User? selectedDoctor;
  DateTime? selectedStartDatetime;
  DateTime? selectedToDatetime;
  List<AvailableTimes>? availableTimes;

  void onSelectedDoctor(User doctor) async {
    try {
      Loader.show();
      final result = await availableTimeProvider.getAvailableTimes(doctor.id);
      setState(() {
        availableTimes = result;
        selectedDoctor = doctor;
      });
    } catch (e) {
      Alert.show(title: "Something when wrong");
    } finally {
      Loader.hide();
    }
  }

  void onSelectedDate(DateTime startDateTime, DateTime toDateTime) {
    setState(() {
      selectedStartDatetime = startDateTime;
      selectedToDatetime = toDateTime;
    });
  }

  void onSubmmit() async {
    if (selectedStartDatetime == null || selectedToDatetime == null || selectedDoctor == null) {
      return;
    }
    try {
      Loader.show();
      await appointmentProvider.create(
          startTime: selectedStartDatetime!, endTime: selectedToDatetime!, doctorId: selectedDoctor!.id);
    } catch (e) {
      Alert.show(title: "Something when wrong");
    } finally {
      Loader.hide();
      Get.offNamed(PageRoutes.home);
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
        title: Padding(
          padding: const EdgeInsets.only(left: kPaddingContainer, right: kPaddingContainer),
          child: Text(selectedDoctor == null ? "Select doctor" : "Select time"),
        ),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: kPaddingContainer, right: kPaddingContainer),
        child: selectedDoctor == null
            ? SelectAppointmentDoctor(
                onSelected: onSelectedDoctor,
              )
            : SelectAppointmentDate(
                availableTimes: availableTimes,
                onSelected: onSelectedDate,
              ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
        child: selectedStartDatetime != null && selectedToDatetime != null
            ? Button(
                backgroundColor: kPrimaryColor,
                onPressed: onSubmmit,
                child: const Text("Make an appointmet", style: TextStyle(fontSize: 17, color: Colors.white)),
              )
            : const SizedBox(),
      ),
    );
  }
}
