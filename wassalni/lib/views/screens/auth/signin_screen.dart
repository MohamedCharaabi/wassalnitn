import 'package:flutter/material.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({Key? key}) : super(key: key);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'username',
              ),
            ),
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
            MaterialButton(
              onPressed: () async {
                final result = await AuthenticationService().emailPassSignUp(
                  _usernameController.text,
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
              child: Text('Google Signup'),
            ),
            GestureDetector(
                onTap: (() => Navigator.pushNamed(context, '/signin')),
                child: const Text("Go to SignIn")),
          ],
        ),
      ),
    );
  }
}
