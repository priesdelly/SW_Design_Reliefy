import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/role.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  final String? userId;
  final String? roleId;
  final Role? role;

  UserRole({this.userId, this.roleId, this.role});

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
