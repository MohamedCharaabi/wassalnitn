import 'package:flutter/material.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: _passController,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          Row(
            children: [
              MaterialButton(
                onPressed: () async {
                  final result = await AuthenticationService().emailPassSignIn(
                    _emailController.text,
                    _passController.text,
                  );
                  // Navigator.pushNamed(context, '/signup');
                  // String? result = await AuthenticationService().googleSignIn();
                  print(result);
                  if (result != null) {
                    Navigator.pushNamed(context, '/home');
                  }
                },
                child: Text('Google SignUp'),
              ),
              GestureDetector(
                  onTap: (() => Navigator.pushNamed(context, '/signup')),
                  child: const Text("Go to SignUp")),
            ],
          ),
        ],
      )),
    );
  }
}
