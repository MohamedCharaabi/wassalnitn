import 'package:flutter/material.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/utils/resusable_widget.dart';
import 'package:wassalni/views/screens/auth/signin_screen.dart';
import 'package:wassalni/views/screens/home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmpasswordTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();

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
              signInSignUpButton(context, false, () async {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const HomeScreen(),
                //   ),
                // );
                final result = await AuthenticationService().emailPassSignUp(
                  _usernameTextController.text,
                  _emailTextController.text,
                  _passwordTextController.text,
                );
                // Navigator.pushNamed(context, '/signup');
                // String? result = await AuthenticationService().googleSignIn();
                print(result);
                if (result != null) {
                  Navigator.pushNamed(context, '/home');
                }
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
                MaterialPageRoute(builder: (context) => SigninScreen()));
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

  //  Row(
  //           children: [
  //             MaterialButton(
  //               onPressed: () async {
  //                 final result = await AuthenticationService().emailPassSignIn(
  //                   _emailController.text,
  //                   _passController.text,
  //                 );
  //                 // Navigator.pushNamed(context, '/signup');
  //                 // String? result = await AuthenticationService().googleSignIn();
  //                 print(result);
  //                 if (result != null) {
  //                   Navigator.pushNamed(context, '/home');
  //                 }
  //               },
  //               child: Text('Google SignUp'),
  //             ),
  //             GestureDetector(
  //                 onTap: (() => Navigator.pushNamed(context, '/signup')),
  //                 child: const Text("Go to SignUp")),
  //           ],
  //         ),
       