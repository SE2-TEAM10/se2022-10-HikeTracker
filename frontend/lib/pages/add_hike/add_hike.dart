import 'package:flutter/material.dart';
import 'package:frontend/pages/add_hike/widget/add_hike_form.dart';
import 'package:frontend/pages/login/widget/login_banner.dart';
import 'package:frontend/utils/rest_client.dart';
import 'package:layout/layout.dart';

class AddHike extends StatefulWidget {
  const AddHike({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<AddHike> createState() => _AddHikeState();
}

class _AddHikeState extends State<AddHike> {
  bool isLoading = false;

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
              AddHikeForm(
                onSubmit: (email, password) => onSubmit(
                  email: email,
                  password: password,
                ),
                isSmall: context.breakpoint <= LayoutBreakpoint.xs,
              ),
            ],
          );
  }

  Future<void> onSubmit({
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

    if (res.body == '"Incorrect username or password."') {
      // TODO
    } else {
      // pop
    }
  }
}
