import 'package:alfi_gest/models/enums.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class UserRole {
  UserRole({
    required this.idUserRole,
    required this.role,
    required this.creationDate,
    required this.updateDate,
    required this.updateUser,
    required this.userCreation,
  });

  final String idUserRole;
  final Role role;
  final DateTime creationDate;
  final String userCreation;
  final DateTime updateDate;
  final String updateUser;

  UserRole copyWith({
    String? idUserRole,
    Role? role,
    DateTime? creationDate,
    String? userCreation,
    DateTime? updateDate,
    String? updateUser,
  }) {
    return UserRole(
      idUserRole: idUserRole ?? this.idUserRole,
      role: role ?? this.role,
      creationDate: creationDate ?? this.creationDate,
      userCreation: userCreation ?? this.userCreation,
      updateDate: updateDate ?? this.updateDate,
      updateUser: updateUser ?? this.updateUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUserRole': idUserRole,
      'role': role.index,
      'creationDate': creationDate.toIso8601String(),
      'userCreation': userCreation,
      'updateDate': updateDate.toIso8601String(),
      'updateUser': updateUser,
    };
  }

  factory UserRole.fromMap(Map<String, dynamic> map) {
    return UserRole(
      idUserRole: map['idUserRole'] as String,
      role: Role.values[map['role'] as int],
      creationDate: DateTime.parse(map['creationDate'] as String),
      userCreation: map['userCreation'] as String,
      updateDate: DateTime.parse(map['updateDate'] as String),
      updateUser: map['updateUser'] as String,
    );
  }
}
