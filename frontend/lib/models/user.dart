import 'dart:convert';

enum UserRole {
  LocalGuide,
  Hiker,
}

class User {
  User({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final UserRole role;

  static User fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return User(
      name: res['name'],
      email: res['username'],
      role: toRole(res['role']),
    );
  }

  static UserRole toRole(String value) {
    switch (value) {
      case 'LocalGuide':
        return UserRole.LocalGuide;
      case 'Hiker':
        return UserRole.Hiker;
      default:
        return UserRole.LocalGuide;
    }
  }
}
