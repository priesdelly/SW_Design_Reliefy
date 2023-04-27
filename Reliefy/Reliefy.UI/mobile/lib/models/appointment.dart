import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/user.dart';
part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  final String? id;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? patientId;
  final User? patient;
  final String? doctorId;
  final User? doctor;
  final int? status;
  final double? score;

  Appointment(
      {this.id, this.startTime, this.endTime, this.patientId, this.patient, this.doctorId, this.doctor, this.status, this.score});
  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
