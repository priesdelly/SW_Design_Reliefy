import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/utils/constant.dart';

class AppointmentItem extends StatelessWidget {
  const AppointmentItem({super.key});

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
                    const Text("นพ.สมชาย ชาติชาย", style: TextStyle(fontSize: 20)),
                    Row(
                      children: const [
                        Chip(label: Text("12/04/2023"), backgroundColor: kBlueLight),
                        SizedBox(width: 10),
                        Chip(label: Text("09:00-12:00"), backgroundColor: kBlueLight),
                      ],
                    ),
                    Button(
                      onPressed: () => {},
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
                    ),
                    // Button(
                    //   onPressed: () => {},
                    //   backgroundColor: Colors.white,
                    //   borderColor: Colors.black,
                    //   height: 45,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: const [
                    //       Padding(
                    //         padding: EdgeInsets.only(left: 10),
                    //         child: Text("Cancel", style: TextStyle(color: Colors.black)),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.only(right: 10),
                    //         child: FaIcon(FontAwesomeIcons.xmark, color: Colors.black),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
