import 'package:flutter/material.dart';
import 'package:mobile/components/time_select_item.dart';
import 'package:mobile/models/available_times.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectAppointmentDate extends StatefulWidget {
  final List<AvailableTimes>? availableTimes;
  final Function(DateTime selectedStartDate, DateTime selectedToDate) onSelected;
  const SelectAppointmentDate({super.key, required this.availableTimes, required this.onSelected});

  @override
  State<SelectAppointmentDate> createState() => _SelectAppointmentDateState();
}

class _SelectAppointmentDateState extends State<SelectAppointmentDate> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focesedDate = DateTime.now();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  List<Widget> getTimesWidget() {
    if (widget.availableTimes == null) return [];
    return widget.availableTimes!
        .where((x) => isSameDay(_selectedDate, x.startTime) && isSameDay(_selectedDate, x.toTime))
        .map(
          (x) => FractionallySizedBox(
            widthFactor: 0.48,
            child: TimeSelectItem(
              onTap: () {
                final startDateTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
                    x.startTime.toLocal().hour, x.startTime.toLocal().minute, 0, 0, 0);
                final toDateTime = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
                    x.toTime.toLocal().hour, x.toTime.toLocal().minute, 0, 0, 0);
                widget.onSelected(startDateTime, toDateTime);
                setState(() {
                  _selectedTime = TimeOfDay(hour: x.startTime.hour, minute: x.startTime.minute);
                });
              },
              label:
                  "${x.startTime.toLocal().hour.toString().padLeft(2, '0')}:${x.startTime.toLocal().minute.toString().padLeft(2, '0')} - ${x.toTime.toLocal().hour.toString().padLeft(2, '0')}:${x.toTime.toLocal().minute.toString().padLeft(2, '0')}",
              isSelected: _selectedTime == TimeOfDay(hour: x.startTime.hour, minute: x.startTime.minute),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focesedDate,
          calendarFormat: _calendarFormat,
          enabledDayPredicate: (day) {
            if (widget.availableTimes == null) return false;
            return widget.availableTimes!.any((e) {
              return isSameDay(day, e.startTime);
            });
          },
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
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.spaceBetween,
                children: getTimesWidget(),
              )
            ],
          ),
        )
      ],
    );
  }
}
