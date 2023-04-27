import 'package:json_annotation/json_annotation.dart';

part 'response_message.g.dart';

@JsonSerializable()
class ResponseMessage {
  final String? status;
  final String? message;

  ResponseMessage({this.status, this.message});

  factory ResponseMessage.fromJson(Map<String, dynamic> json) => _$ResponseMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseMessageToJson(this);
}