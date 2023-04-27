// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableTimes _$AvailableTimesFromJson(Map<String, dynamic> json) =>
    AvailableTimes(
      startTime: DateTime.parse(json['startTime'] as String),
      toTime: DateTime.parse(json['toTime'] as String),
      doctorId: json['doctorId'] as String,
    );

Map<String, dynamic> _$AvailableTimesToJson(AvailableTimes instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'toTime': instance.toTime.toIso8601String(),
      'doctorId': instance.doctorId,
    };
