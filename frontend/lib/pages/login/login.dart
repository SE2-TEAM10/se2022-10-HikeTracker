import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/login/widget/login_banner.dart';
import 'package:HikeTracker/pages/login/widget/login_form.dart';
import 'package:HikeTracker/pages/login/widget/signup_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
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
  bool showControls = false;
  late double position;
  late PageController controller;

  @override
  void initState() {
    position = 0;
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(
        () => setState(() {
          position = controller.page ?? 0;
        }),
      );

      setState(() => showControls = true);
    });
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
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: controller,
                        children: [
                          LoginForm(
                            onSubmit: (email, password) => onSubmit(
                              email: email,
                              password: password,
                            ),
                            onSignupTap: () => controller.animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: 400,
                              ),
                              curve: Curves.linear,
                            ),
                            isSmall: context.breakpoint <= LayoutBreakpoint.xs,
                          ),
                          SignupForm(
                            onSubmit: (
                              email,
                              password,
                              confirm,
                              role,
                            ) =>
                                onSignUp(
                              email: email,
                              password: password,
                              confirm: confirm,
                              role: role,
                            ),
                            onLoginTap: () => controller.animateToPage(
                              0,
                              duration: const Duration(
                                milliseconds: 400,
                              ),
                              curve: Curves.linear,
                            ),
                            isSmall: context.breakpoint <= LayoutBreakpoint.xs,
                          ),
                        ],
                      ),
                    ),
                    context.breakpoint > LayoutBreakpoint.xs
                        ? PageViewIndicators(
                            showControls: showControls,
                            position: position,
                          )
                        : Container()
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
      widget.onLogged(null);
    } else {
      widget.onLogged(User.fromJson(res.body));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> onSignUp({
    required String email,
    required String password,
    required String confirm,
    required UserRole role,
  }) async {
    if (password != confirm) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    //BE CALL TO CREATE AN ACCOUNT AND TRIGGER CONFIRMATION EMAIL

    // final res = await widget.client.post(
    //   api: 'sessions',
    //   body: {
    //     'username': email,
    //     'password': password,
    //     'role': role.name,
    //   },
    // );

    setState(() {
      isLoading = false;
    });
  }
}

class PageViewIndicators extends StatelessWidget {
  const PageViewIndicators({
    required this.showControls,
    required this.position,
    super.key,
  });

  final bool showControls;
  final double position;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 64.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: showControls
            ? [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: position < 0.5
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: position >= .5
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                )
              ]
            : [],
      ),
    );
  }
}
