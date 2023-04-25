import 'package:flutter/material.dart';

import '../utils/constant.dart';

class TimeSelectItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final void Function() onTap;
  const TimeSelectItem({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : Colors.transparent,
          border: Border.all(color: kBlueLight.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
