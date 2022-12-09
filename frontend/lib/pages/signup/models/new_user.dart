import 'package:HikeTracker/models/user.dart';

class NewUser {
  NewUser({
    required this.role,
    this.name,
    this.surname,
    this.email,
    this.password,
    this.confirm,
  });

  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final String? confirm;
  final UserRole role;

  Map<String, dynamic> toMap() => {
        'name': name,
        'surname': surname,
        'mail': email,
        'role': role.name,
        'password': password,
      };

  bool isFull() =>
      name != null &&
      surname != null &&
      email != null &&
      password != null &&
      confirm != null;

  bool isPasswordValid() {
    if (password!.length < 8) return false;
    if (!password!.contains(RegExp(r"[a-z]"))) return false;
    if (!password!.contains(RegExp(r"[A-Z]"))) return false;
    if (!password!.contains(RegExp(r"[0-9]"))) return false;
    return true;
  }


  bool passwordMatches() => password == confirm;

  NewUser copyWith({
    String? name,
    String? surname,
    String? email,
    String? password,
    String? confirm,
    UserRole? role,
  }) =>
      NewUser(
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        password: password ?? this.password,
        confirm: confirm ?? this.confirm,
        role: role ?? this.role,
      );
}
