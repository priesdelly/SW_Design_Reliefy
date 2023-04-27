import 'package:json_annotation/json_annotation.dart';
part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final String? id;
  final String? message;
  final String? chatSessionId;
  final String? senderId;
  final String? receiverId;
  final bool? isRead;

  Chat({this.id, this.message, this.chatSessionId, this.senderId, this.receiverId, this.isRead});

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
