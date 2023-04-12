import 'package:json_annotation/json_annotation.dart';
part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  final String? doctorName;
  final DateTime? appointmentDate;

  Appointment({this.doctorName, this.appointmentDate});
  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
