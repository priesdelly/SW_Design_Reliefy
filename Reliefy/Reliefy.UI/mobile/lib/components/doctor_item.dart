import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/utils/constant.dart';

import '../models/user.dart';

class DoctorItem extends StatelessWidget {
  final bool isSelected;
  final User user;

  String getFullName() {
    return "${user.firstname ?? ""} ${user.lastname ?? ""}";
  }

  const DoctorItem({
    super.key,
    required this.isSelected,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSelected ? kSecondaryColor : Colors.transparent,
        border: Border.all(color: kBlueLight.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.userDoctor,
                  color: isSelected ? Colors.white : Colors.black,
                  size: 35,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  getFullName(),
                  style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            isSelected
                ? const FaIcon(
                    FontAwesomeIcons.circleCheck,
                    color: Colors.white,
                    size: 35,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
