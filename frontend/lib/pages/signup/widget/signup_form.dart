import 'package:HikeTracker/common/input_field.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/signup/models/new_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    required this.onSubmit,
    required this.onLoginTap,
    this.isSmall = false,
    super.key,
  });

  final bool isSmall;
  final Function(
    NewUser,
  ) onSubmit;
  final Function onLoginTap;

  @override
  State<SignupForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<SignupForm> {
  late NewUser user;

  @override
  void initState() {
    user = NewUser(role: UserRole.LocalGuide);
    super.initState();
  }

  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: widget.isSmall ? 16 : 128,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Create an account',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Insert your data and start using HikeTracker.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          FractionallySizedBox(
            widthFactor: widget.isSmall ? 1 : 0.6,
            child: Row(
              children: [
                Expanded(
                  child: InputField(
                    onChange: (value) =>
                        setState(() => user = user.copyWith(name: value)),
                    label: 'Name',
                  ),
                ),
                SizedBox(
                  width: widget.isSmall ? 8 : 16,
                ),
                Expanded(
                  child: InputField(
                    onChange: (value) =>
                        setState(() => user = user.copyWith(surname: value)),
                    label: 'Surname',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.isSmall ? 8 : 32,
          ),
          FractionallySizedBox(
            widthFactor: widget.isSmall ? 1 : 0.6,
            child: InputField(
              onChange: (value) =>
                  setState(() => user = user.copyWith(email: value)),
              label: 'Email',
            ),
          ),
          SizedBox(
            height: widget.isSmall ? 8 : 32,
          ),
          FractionallySizedBox(
            widthFactor: widget.isSmall ? 1 : 0.6,
            child: InputField(
              onChange: (value) =>
                  setState(() => user = user.copyWith(password: value)),
              controller: _passwordController,
              label: 'Password',
              isPassword: true,
            ),
          ),SizedBox(
            height: widget.isSmall ? 8 : 32,
          ),
          FlutterPwValidator(
              controller: _passwordController,
              minLength: 8,
              uppercaseCharCount: 1,
              numericCharCount: 1,
              normalCharCount: 1,
              width: 350,
              height: 150,
              onSuccess: () => '',
              onFail: () => ''
          ),
          SizedBox(
            height: widget.isSmall ? 8 : 32,
          ),
          FractionallySizedBox(
            widthFactor: widget.isSmall ? 1 : 0.6,
            child: InputField(
              onChange: (value) =>
                  setState(() => user = user.copyWith(confirm: value)),
              label: 'Confirm Password',
              isPassword: true,
            ),
          ),
          FractionallySizedBox(
            widthFactor: widget.isSmall ? 1 : 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Role',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Local Guide',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio(
                          value: UserRole.LocalGuide,
                          activeColor: Theme.of(context).colorScheme.primary,
                          groupValue: user.role,
                          onChanged: (UserRole? value) => setState(
                            () => user = user.copyWith(
                              role: value ?? UserRole.LocalGuide,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: widget.isSmall ? 8 : 32,
          ),
          TextButton.icon(
            onPressed: user.isFull()
                ? () => widget.onSubmit(
                      user,
                    )
                : null,
            icon: const Icon(Icons.account_box_outlined),
            label: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Create',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          TextButton(
            onPressed: () => widget.onLoginTap(),
            child: Text(
              'Do you already have an account? Login',
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
