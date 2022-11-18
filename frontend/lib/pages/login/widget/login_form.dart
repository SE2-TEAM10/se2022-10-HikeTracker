import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.onSubmit,
    this.isSmall = false,
    Key? key,
  }) : super(key: key);

  final bool isSmall;
  final Function(String, String) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController(text: 'john.doe@hike.it');
    passwordController = TextEditingController(text: 'localguide1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: widget.isSmall ? 16 : 128,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Some text that goes under the login',
              style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => widget.onSubmit(
                        emailController.text,
                        passwordController.text,
                      ),
                      icon: const Icon(Icons.login),
                      label: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
