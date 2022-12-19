import 'package:HikeTracker/common/login_banner.dart';
import 'package:HikeTracker/common/message.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/login/widget/login_form.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Row(
            children: [
              if (!context.isMobile) const LoginBanner(),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: LoginForm(
                        onSubmit: (email, password) => onSubmit(
                          email: email,
                          password: password,
                        ),
                        onSignupTap: () =>
                            GoRouter.of(context).replace('/signup'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Future<void> onSubmit({
    required String email,
    required String password,
  }) async {
    setState(() {
      isLoading = true;
    });
    final res = await widget.client.post(
      api: 'sessions',
      body: {
        'username': email,
        'password': password,
      },
    );

    if (res.body == '"Incorrect username or password."') {
      Message(
        context: context,
        message: 'Wrong Email or Password',
        messageType: MessageType.Error,
      ).show();
    } else if (res.body == '"User is not verified."') {
      Message(
        context: context,
        message: 'This account has not been verified yet. Check your email.',
        messageType: MessageType.Error,
      ).show();
    } else {
      final user = User.fromJson(res.body);
      Message(
        context: context,
        message: 'Welcome back ${user.name}',
      ).show();
      widget.onLogged(user);
    }
    setState(() {
      isLoading = false;
    });
  }
}
