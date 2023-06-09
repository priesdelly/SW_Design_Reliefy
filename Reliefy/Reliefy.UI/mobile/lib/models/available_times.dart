import 'package:json_annotation/json_annotation.dart';
part 'available_times.g.dart';

@JsonSerializable()
class AvailableTimes {
  final DateTime startTime;
  final DateTime toTime;
  final String doctorId;

  AvailableTimes({required this.startTime, required this.toTime, required this.doctorId});
  factory AvailableTimes.fromJson(Map<String, dynamic> json) => _$AvailableTimesFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableTimesToJson(this);
}
