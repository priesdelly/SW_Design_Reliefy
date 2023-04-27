// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String?,
      message: json['message'] as String?,
      chatSessionId: json['chatSessionId'] as String?,
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      isRead: json['isRead'] as bool?,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'chatSessionId': instance.chatSessionId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'isRead': instance.isRead,
    };
