import 'package:flutter/material.dart';
import 'package:wassalni/views/screens/auth/signin_screen.dart';
import 'package:wassalni/views/screens/home/home_screen.dart';

import '../../../utils/resusable_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

final TextEditingController _passwordTextController = TextEditingController();
final TextEditingController _confirmpasswordTextController =
    TextEditingController();
final TextEditingController _emailTextController = TextEditingController();
final TextEditingController _usernameTextController = TextEditingController();

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF404240),
          Color(0xFF2B2D2B),
          Color(0xFF000000)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              //logowidget('assets/images/logo1.png'),
              const SizedBox(
                height: 30,
              ),
              resuableTextField("Enter Your Username", Icons.person_outline,
                  false, _usernameTextController),
              const SizedBox(
                height: 30,
              ),
              resuableTextField("Enter Email", Icons.email_outlined, false,
                  _emailTextController),

              const SizedBox(
                height: 20,
              ),
              resuableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              resuableTextField("Confirm Your Password", Icons.lock_outline,
                  true, _confirmpasswordTextController),
              const SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }),
              singInOption(),
            ],
          ),
        )),
      ),
    );
  }

  Row singInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SigninScreen()));
          },
          child: const Text(
            "  Sign In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
