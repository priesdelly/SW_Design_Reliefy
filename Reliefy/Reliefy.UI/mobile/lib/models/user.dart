import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String? googleUid;
  final String? signInType;
  final String? firstname;
  final String? lastname;
  final String email;
  final String? phoneNumber;

  User({required this.id, this.googleUid, this.signInType, this.firstname, this.lastname,required this.email, this.phoneNumber});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
