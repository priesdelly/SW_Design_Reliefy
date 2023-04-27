// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      googleUid: json['googleUid'] as String?,
      signInType: json['signInType'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      isCompleteInfo: json['isCompleteInfo'] as bool?,
      isVerified: json['isVerified'] as bool?,
      userRoles: (json['userRoles'] as List<dynamic>?)
          ?.map((e) => UserRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'googleUid': instance.googleUid,
      'signInType': instance.signInType,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'isVerified': instance.isVerified,
      'isCompleteInfo': instance.isCompleteInfo,
      'userRoles': instance.userRoles,
    };
