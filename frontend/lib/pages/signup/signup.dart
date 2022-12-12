import 'package:HikeTracker/common/login_banner.dart';
import 'package:HikeTracker/common/message.dart';
import 'package:HikeTracker/pages/signup/models/new_user.dart';
import 'package:HikeTracker/pages/signup/widget/signup_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layout/layout.dart';

class Signup extends StatefulWidget {
  const Signup({
    required this.client,
    required this.onLogged,
    super.key,
  });

  final RestClient client;
  final Function onLogged;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Row(
            children: [
              if (context.breakpoint >= LayoutBreakpoint.md)
                const LoginBanner(),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SignupForm(
                        onSubmit: (
                          user,
                        ) =>
                            onSignUp(
                          user: user,
                        ),
                        onLoginTap: () =>
                            GoRouter.of(context).replace('/login'),
                        isSmall: context.breakpoint <= LayoutBreakpoint.xs,
                        onPwdFail: () =>
                            setState(() => isPasswordValid = false),
                        onPwdSuccess: () =>
                            setState(() => isPasswordValid = true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Future<void> onSignUp({
    required NewUser user,
  }) async {
    if (!user.passwordMatches()) {
      Message(
        context: context,
        message: 'Password confirm does not match.',
        messageType: MessageType.Error,
      ).show();
      return;
    } else if (!isPasswordValid) {
      Message(
        context: context,
        message: 'Password does not match all the criterias',
        messageType: MessageType.Error,
      ).show();
      return;
    }

    setState(() {
      isLoading = true;
    });

    await widget.client.post(
      api: 'addUser',
      body: user.toMap(),
    );

    Message(
      context: context,
      message: 'A confirmation email has been send to ${user.email}',
      messageType: MessageType.Info,
    ).show();

    setState(() {
      isLoading = false;
    });
  }
}
