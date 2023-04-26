import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/components/doctor_item.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/providers/user_provider.dart';

class SelectAppointmentDoctor extends StatefulWidget {
  final Function(User doctor) onSelected;
  const SelectAppointmentDoctor({super.key, required this.onSelected});

  @override
  State<SelectAppointmentDoctor> createState() => _SelectAppointmentDoctorState();
}

class _SelectAppointmentDoctorState extends State<SelectAppointmentDoctor> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Get.find();
    return FutureBuilder(
      future: userProvider.getListDoctors(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () {
                      widget.onSelected(snapshot.data!.elementAt(i));
                      setState(() {
                        selectedIndex = i;
                      });
                    },
                    child: DoctorItem(isSelected: selectedIndex == i, user: snapshot.data!.elementAt(i)),
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error occur"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
