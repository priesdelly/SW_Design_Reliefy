import 'package:json_annotation/json_annotation.dart';

import 'chat.dart';
part 'chat_session.g.dart';

@JsonSerializable()
class ChatSession {
  final String? id;
  final String? appointmentId;
  final List<Chat>? chats;

  ChatSession({this.id, this.appointmentId, this.chats});

  factory ChatSession.fromJson(Map<String, dynamic> json) => _$ChatSessionFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);
}
