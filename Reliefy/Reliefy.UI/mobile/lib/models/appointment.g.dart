// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      patientId: json['patientId'] as String?,
      patient: json['patient'] == null
          ? null
          : User.fromJson(json['patient'] as Map<String, dynamic>),
      doctorId: json['doctorId'] as String?,
      doctor: json['doctor'] == null
          ? null
          : User.fromJson(json['doctor'] as Map<String, dynamic>),
      status: json['status'] as int?,
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'patientId': instance.patientId,
      'patient': instance.patient,
      'doctorId': instance.doctorId,
      'doctor': instance.doctor,
      'status': instance.status,
    };
