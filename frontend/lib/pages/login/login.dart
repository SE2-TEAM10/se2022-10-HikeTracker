import 'package:flutter/material.dart';
import 'package:frontend/pages/login/widget/login_banner.dart';
import 'package:frontend/pages/login/widget/login_form.dart';
import 'package:frontend/rest_client.dart';
import 'package:layout/layout.dart';

class Login extends StatefulWidget {
  const Login({
    required this.client,
    required this.onLogged,
    super.key,
  });

  final RestClient client;
  final Function onLogged;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: [
                if (context.breakpoint >= LayoutBreakpoint.md)
                  const LoginBanner(),
                LoginForm(
                  onSubmit: (email, password) => onSubmit(
                    email: email,
                    password: password,
                  ),
                  isSmall: context.breakpoint <= LayoutBreakpoint.xs,
                ),
              ],
            ),
    );
  }

  onSubmit({
    required String email,
    required String password,
  }) async {
    final res = await widget.client.post(
      api: 'sessions',
      body: {
        'username': email,
        'password': password,
      },
    );

    if (res.body == "\"Incorrect username or password.\"") {
      widget.onLogged(false);
    } else {
      widget.onLogged(true);
    }
  }
}
