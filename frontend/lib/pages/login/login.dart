import 'package:flutter/material.dart';
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
    // emailController = TextEditingController();
    // passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.isSmall ? 8 : 64.0,
            horizontal: widget.isSmall ? 16 : 128.0,
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
                          color: Colors.black.withOpacity(0.6),
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
                            color: Colors.black.withOpacity(0.6),
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
                          color: Colors.black.withOpacity(0.6),
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
                            color: Colors.black.withOpacity(0.6),
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
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginBanner extends StatelessWidget {
  const LoginBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(
                16.0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 64.0,
              horizontal: 64.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hike\nTracker',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Always right\non track with us.',
                      style: TextStyle(
                        fontSize: 46.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Discover Italy most beautiful hike tracks.\nKeep records of your experiences and share with others.',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
