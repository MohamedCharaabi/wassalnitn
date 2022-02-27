import 'package:flutter/material.dart';
import 'package:wassalni/modelView/services/authentication_service.dart';
import 'package:wassalni/utils/resusable_widget.dart';
import 'package:wassalni/views/screens/auth/signup_screen.dart';
// import 'package:wassalni/views/screens/home/home_screen.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key? key}) : super(key: key);
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passController = TextEditingController();

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

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
              resuableTextField("Enter Email", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              resuableTextField(
                  "Enter Password", Icons.lock, true, _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, true, () async {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const HomeScreen(),
                //   ),
                // );

                final result = await AuthenticationService().emailPassSignIn(
                  _emailTextController.text,
                  _passwordTextController.text,
                  context,
                );
                // Navigator.pushNamed(context, '/signup');
                // String? result = await AuthenticationService().googleSignIn();
                print(result);
                if (result != null) {
                  Navigator.pushNamed(context, '/home');
                }
              }),
              singUpOption(),
            ],
          ),
        )),
      ),
    );
  }

  Row singUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignupScreen()));
          },
          child: const Text(
            "  Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}


  // MaterialButton(
  //             onPressed: () async {
  //               final result = await AuthenticationService().emailPassSignUp(
  //                 _usernameController.text,
  //                 _emailController.text,
  //                 _passController.text,
  //               );
  //               // Navigator.pushNamed(context, '/signup');
  //               // String? result = await AuthenticationService().googleSignIn();
  //               print(result);
  //               if (result != null) {
  //                 Navigator.pushNamed(context, '/home');
  //               }
  //             },
  //             child: Text('Google Signup'),
  //           ),
  //           GestureDetector(
  //               onTap: (() => Navigator.pushNamed(context, '/signin')),
  //               child: const Text("Go to SignIn")),
         

