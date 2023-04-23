import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/components/time_select_item.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/constant.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() => _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focesedDate = DateTime.now();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool showDate = true;

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
          child: Text("Appointment"),
        ),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: kPaddingContainer, right: kPaddingContainer),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focesedDate,
              calendarFormat: _calendarFormat,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronMargin: EdgeInsets.all(0),
                rightChevronMargin: EdgeInsets.all(0),
                leftChevronPadding: EdgeInsets.all(0),
                rightChevronPadding: EdgeInsets.all(0),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay)) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focesedDate = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focesedDate = focusedDay;
              },
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TimeSelectItem(
                      onTap: () => setState(() {
                        _selectedTime = const TimeOfDay(hour: 10, minute: 00);
                      }),
                      label: "10.00 - 11.00",
                      isSelected: _selectedTime == const TimeOfDay(hour: 10, minute: 00),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TimeSelectItem(
                      onTap: () => setState(() {
                        _selectedTime = const TimeOfDay(hour: 11, minute: 00);
                      }),
                      label: "11.00 - 12.00",
                      isSelected: _selectedTime == const TimeOfDay(hour: 11, minute: 00),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TimeSelectItem(
                      onTap: () => setState(() {
                        _selectedTime = const TimeOfDay(hour: 14, minute: 00);
                      }),
                      label: "14.00 - 15.00",
                      isSelected: _selectedTime == const TimeOfDay(hour: 14, minute: 00),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TimeSelectItem(
                      onTap: () => setState(() {
                        _selectedTime = const TimeOfDay(hour: 15, minute: 00);
                      }),
                      label: "15.00 - 16.00",
                      isSelected: _selectedTime == const TimeOfDay(hour: 15, minute: 00),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TimeSelectItem(
                      onTap: () => setState(() {
                        _selectedTime = const TimeOfDay(hour: 16, minute: 00);
                      }),
                      label: "16.00 - 17.00",
                      isSelected: _selectedTime == const TimeOfDay(hour: 16, minute: 00),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TimeSelectItem(
                      onTap: () => setState(() {
                        _selectedTime = const TimeOfDay(hour: 17, minute: 00);
                      }),
                      label: "17.00 - 18.00",
                      isSelected: _selectedTime == const TimeOfDay(hour: 17, minute: 00),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
